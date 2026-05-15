//
//  LeagueDetailsPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//



import Foundation

enum LeagueDetailsSection: Int, CaseIterable {
    case teams = 0
    case upcoming
    case latest

    var title: String {
        switch self {
        case .teams:    return "Teams"
        case .upcoming: return "Upcoming Events"
        case .latest:   return "Latest Events"
        }
    }
}

protocol LeagueDetailsPresenterProtocol: AnyObject {
    var visibleSections: [LeagueDetailsSection] { get }
    func upcomingEvents(for section: LeagueDetailsSection) -> [Fixture]
    func latestEvents(for section: LeagueDetailsSection) -> [Fixture]
    func teams(for section: LeagueDetailsSection) -> [TeamDetails]
    func numberOfItems(in section: LeagueDetailsSection) -> Int
    func isEmpty(section: LeagueDetailsSection) -> Bool
    var isFavorite: Bool { get }
    func viewDidLoad()
    func toggleFavorite()
    func didSelectTeam(at index: Int)
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    private weak var view: LeagueDetailsViewProtocol?
    private let repo: SportixRepo
    private let league: League
    private let reachability : ReachabilityManager = .shared
    private var upcomingEventsData: [Fixture] = []
    private var latestEventsData: [Fixture] = []
    private var teamsData: [TeamDetails] = []

    var visibleSections: [LeagueDetailsSection] {
        LeagueDetailsSection.allCases
    }

    var isFavorite: Bool {
        repo.isLeagueFavorite(id: league.id)
    }

    init(view: LeagueDetailsViewProtocol, league: League, repo: SportixRepo = SportixRepoImp()) {
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

    func isEmpty(section: LeagueDetailsSection) -> Bool {
        switch section {
        case .teams:    return teamsData.isEmpty
        case .upcoming: return upcomingEventsData.isEmpty
        case .latest:   return latestEventsData.isEmpty
        }
    }

    func numberOfItems(in section: LeagueDetailsSection) -> Int {
        if isEmpty(section: section) { return 1 }
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
    
    func didSelectTeam(at index: Int) {
        guard reachability.isConnected else {
            view?.showNoInternetAlert()
            return
        }
        guard !isEmpty(section: .teams) else { return }
        guard index >= 0 && index < teamsData.count else { return }
        let selectedTeam = teamsData[index]
        view?.navigateToTeamDetails(sport: league.sport, teamId: selectedTeam.id)
    }

    @MainActor
    private func fetchLeagueDetails() async {
        view?.showLoading()
        view?.setFavoriteButton(enabled: false)
        
        defer { view?.hideLoading() }

        do {
            async let upcoming     = repo.fetchUpcomingFixtures(sport: league.sport, leagueId: league.id)
            async let past         = repo.fetchPastFixtures(sport: league.sport, leagueId: league.id)
            async let leagueTeams  = repo.fetchTeams(sport: league.sport, leagueId: league.id)

            upcomingEventsData = try await upcoming
            
            let fetchedPastFixtures = try await past
            latestEventsData = fetchedPastFixtures.filter { fixture in
                let homeScore = fixture.homeTeamScore.trimmingCharacters(in: .whitespaces)
                let awayScore = fixture.awayTeamScore.trimmingCharacters(in: .whitespaces)
                return !homeScore.isEmpty && !awayScore.isEmpty
            }
            
            teamsData = try await leagueTeams
            view?.setFavoriteButton(enabled: true)
        } catch {
            print(error.localizedDescription)
        }
        view?.reloadData()
    }
}
