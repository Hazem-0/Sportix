//
//  SportixRepoImp.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 06/05/2026.
//

import Foundation

class SportixRepoImp: SportixRepo {
    
    private let appSettings: AppSettingsLocalDataSourceProtocol
    private let coreData: CoreDataManager
    private let networkManager: NetworkManager
    
    init(
        appSettings: AppSettingsLocalDataSourceProtocol = AppSettingsLocalDataSource(),
        coreData: CoreDataManager = CoreDataManager.shared,
        networkManager: NetworkManager = NetworkManager.shared
    ) {
        self.appSettings = appSettings
        self.coreData = coreData
        self.networkManager = networkManager
    }
    
    func hasSeenOnboarding() -> Bool {
        return appSettings.hasSeenOnboarding()
    }
    
    func markOnboardingAsSeen() {
        appSettings.markOnboardingAsSeen()
    }
    
    func saveFavLeague(league: League) {
        coreData.saveFavorite(league: league)
    }
    
    func getAllFavoriteLeagues() -> [League] {
        let entities = coreData.fetchAllFavorites()
        if entities.isEmpty {
            return [
                League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png")
            ]
        }
        return entities.map { $0.toLeague() }
    }
    
    func removeFavLeague(id: Int) {
        coreData.removeFavorite(leagueId: id)
    }
    
    func isLeagueFavorite(id: Int) -> Bool {
        coreData.isFavorite(leagueId: id)
    }
    
    func fetchLeagues(sport: Sport) async throws -> [League] {
        let responses = try await networkManager.fetchLeagues(sport: sport.displayName)
        return responses.map { $0.toDomain(sport: sport) }
    }
    
    func fetchUpcomingFixtures(sport: Sport, leagueId: Int) async throws -> [Fixture] {
        let responses = try await networkManager.fetchUpcomingFixtures(sport: sport.displayName, leagueId: leagueId)
        return responses.map { $0.toDomain() }
    }
    
    func fetchPastFixtures(sport: Sport, leagueId: Int) async throws -> [Fixture] {
        let responses = try await networkManager.fetchPastFixtures(sport: sport.displayName, leagueId: leagueId)
        return responses.map { $0.toDomain() }
    }
    
    func fetchTeams(sport: Sport, leagueId: Int) async throws -> [TeamDetails] {
        let responses = try await networkManager.fetchTeams(sport: sport.displayName, leagueId: leagueId)
        return responses.map { $0.toDomain() }
    }
}
