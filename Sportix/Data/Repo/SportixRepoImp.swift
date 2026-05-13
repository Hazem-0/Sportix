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
    
    func getSavedTheme() -> Int {
        appSettings.getSavedTheme()
    }
    
    func saveTheme(themeType: Int) {
        appSettings.saveTheme(themeType: themeType)
    }
    
    func saveFavLeague(league: League) {
        coreData.saveFavorite(league: league)
    }
    
    func getAllFavoriteLeagues() -> [League] {
        let entities = coreData.fetchAllFavorites()
       
        return entities.map { $0.toLeague() }
    }
    
    func removeFavLeague(id: Int) {
        coreData.removeFavorite(leagueId: id)
    }
    
    func isLeagueFavorite(id: Int) -> Bool {
        return coreData.isFavorite(leagueId: id)
    }
    
    func getLeagues(for sport: Sport) async throws -> [League] {
        let leagueResponses = try await networkManager.fetchLeagues(sport: sport)

                let leagues = leagueResponses.compactMap { response in
                    response.toLeague(sport: sport)
                }

                return leagues
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
        let responses = try await networkManager.fetchTeams(
            sport: sport,
            leagueId: leagueId
        )
        return responses.map { $0.toDomain() }
    }

    func fetchTeamDetails(sport: Sport, teamId: Int) async throws -> TeamDetails {
        let response = try await networkManager.fetchTeamDetails(
            sport: sport,
            teamId: teamId
        )
        return response.toDomain()
    }
}
