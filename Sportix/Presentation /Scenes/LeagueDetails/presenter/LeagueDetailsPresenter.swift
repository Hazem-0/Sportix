//
//  LeagueDetailsPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import Foundation

enum LeagueDetailsSection: Int, CaseIterable {
    case upcoming = 0
    case latest
    case teams

    var title: String {
        switch self {
        case .upcoming: return "Upcoming Events"
        case .latest:   return "Latest Events"
        case .teams:    return "Teams"
        }
    }
}

protocol LeagueDetailsPresenterProtocol: AnyObject {
    var visibleSections: [LeagueDetailsSection] { get }

    func upcomingEvents(for section: LeagueDetailsSection) -> [Fixture]
    func latestEvents(for section: LeagueDetailsSection) -> [Fixture]
    func teams(for section: LeagueDetailsSection) -> [TeamDetails]
    func numberOfItems(in section: LeagueDetailsSection) -> Int

    var isFavorite: Bool { get }

    func viewDidLoad()
    func toggleFavorite()
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {

    private weak var view: LeagueDetailsViewProtocol?
    private let repo: SportixRepo
    private let league: League

    private var upcomingEventsData: [Fixture] = []
    private var latestEventsData: [Fixture] = []
    private var teamsData: [TeamDetails] = []

    var visibleSections: [LeagueDetailsSection] {
        LeagueDetailsSection.allCases.filter { numberOfItems(in: $0) > 0 }
    }

    var isFavorite: Bool {
        repo.isLeagueFavorite(id: league.id)
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

    func upcomingEvents(for section: LeagueDetailsSection) -> [Fixture] {
        section == .upcoming ? upcomingEventsData : []
    }

    func latestEvents(for section: LeagueDetailsSection) -> [Fixture] {
        section == .latest ? latestEventsData : []
    }

    func teams(for section: LeagueDetailsSection) -> [TeamDetails] {
        section == .teams ? teamsData : []
    }

    func numberOfItems(in section: LeagueDetailsSection) -> Int {
        switch section {
        case .upcoming: return upcomingEventsData.count
        case .latest:   return latestEventsData.count
        case .teams:    return teamsData.count
        }
    }

    func viewDidLoad() {
        Task { await fetchLeagueDetails() }
    }

    func toggleFavorite() {
        if repo.isLeagueFavorite(id: league.id) {
            repo.removeFavLeague(id: league.id)
            view?.showToast(message: "Removed from favorites", icon: "trash.fill")
        } else {
            repo.saveFavLeague(league: league)
            view?.showToast(message: "Added to favorites", icon: "checkmark.circle.fill")
        }
        view?.updateFavoriteButton(isFavorite: isFavorite)
    }

    @MainActor
    private func fetchLeagueDetails() async {
        view?.showLoading()
        defer { view?.hideLoading() }

        do {
            async let upcoming     = repo.fetchUpcomingFixtures(sport: league.sport, leagueId: league.id)
            async let past         = repo.fetchPastFixtures(sport: league.sport, leagueId: league.id)
            async let leagueTeams  = repo.fetchTeams(sport: league.sport, leagueId: league.id)

            upcomingEventsData = try await upcoming
            latestEventsData   = try await past
            teamsData          = try await leagueTeams
        } catch {
            print(error.localizedDescription)
        }

        view?.reloadData()
    }
}
