//
//  LeagueDetailsPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import Foundation

protocol LeagueDetailsPresenterProtocol: AnyObject {
    var upcomingEvents: [Fixture] { get }
    var latestEvents: [Fixture] { get }
    var teams: [TeamDetails] { get }
    var isFavorite: Bool { get }

    func viewDidLoad()
    func toggleFavorite()
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {

    weak var view: LeagueDetailsViewProtocol?
    private let repo: SportixRepo
    private let league: League

    var upcomingEvents: [Fixture] = []
    var latestEvents: [Fixture] = []
    var teams: [TeamDetails] = []

    var isFavorite: Bool {
        return repo.isLeagueFavorite(id: league.id)
    }

    init(
        view: LeagueDetailsViewProtocol,
        league: League,
        repo: SportixRepo = SportixRepoImp()
    ) {
        self.view = view
        self.league = league
        self.repo = repo
    }

    func viewDidLoad() {
        Task {
            await fetchLeagueDetails()
        }
    }

    func toggleFavorite() {
        if repo.isLeagueFavorite(id: league.id) {
            repo.removeFavLeague(id: league.id)
            view?.showToast(message: "Removed from favorites", icon: "trash.fill")
        } else {
            repo.saveFavLeague(league: league)
            view?.showToast(message: "Added to favorites", icon: "checkmark.circle.fill")
        }
        view?.updateFavoriteButton(isFavorite: repo.isLeagueFavorite(id: league.id))
    }

    @MainActor
    private func fetchLeagueDetails() async {
        view?.showLoading()

        defer {
            view?.hideLoading()
        }

        do {
            async let upcoming = repo.fetchUpcomingFixtures(sport: league.sport, leagueId: league.id)
            async let past = repo.fetchPastFixtures(sport: league.sport, leagueId: league.id)
            async let leagueTeams = repo.fetchTeams(sport: league.sport, leagueId: league.id)

            self.upcomingEvents = try await upcoming
            self.latestEvents = try await past
            self.teams = try await leagueTeams

            view?.reloadData()
        } catch {
            print(error.localizedDescription)
            view?.reloadData()
        }
    }
}
