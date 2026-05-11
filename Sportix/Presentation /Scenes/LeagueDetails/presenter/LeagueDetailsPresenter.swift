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
    
    func viewDidLoad()
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    weak var view: LeagueDetailsViewProtocol?
    private let repo: SportixRepo
    private let sport: Sport
    private let leagueId: Int
    
    var upcomingEvents: [Fixture] = []
    var latestEvents: [Fixture] = []
    var teams: [TeamDetails] = []
    
    init(view: LeagueDetailsViewProtocol, repo: SportixRepo = SportixRepoImp(), sport: Sport, leagueId: Int) {
        self.view = view
        self.repo = repo
        self.sport = sport
        self.leagueId = leagueId
    }
    
    func viewDidLoad() {
        Task {
            await fetchLeagueDetails()
        }
    }
    
    @MainActor
    private func fetchLeagueDetails() async {
        view?.showLoading()
        
        defer {
            view?.hideLoading()
        }
        
        do {
            async let upcoming = repo.fetchUpcomingFixtures(sport: sport, leagueId: leagueId)
            async let past = repo.fetchPastFixtures(sport: sport, leagueId: leagueId)
            async let leagueTeams = repo.fetchTeams(sport: sport, leagueId: leagueId)
            
            self.upcomingEvents = try await upcoming
            self.latestEvents = try await past
            self.teams = try await leagueTeams
            
            print("\(upcomingEvents.count)")
            view?.reloadData()
        } catch {
            print(error.localizedDescription)
            view?.reloadData()
        }
    }
}
