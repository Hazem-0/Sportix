//
//  SportixRepoImp.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 06/05/2026.
//

import Foundation

class SportixRepoImp : SportixRepo{
    
  
    
private let appSettings: AppSettingsLocalDataSourceProtocol
private let coreData: CoreDataManager
        
    init(
            appSettings: AppSettingsLocalDataSourceProtocol = AppSettingsLocalDataSource(),
            coreData: CoreDataManager = CoreDataManager.shared
        ) {
            self.appSettings = appSettings
            self.coreData = coreData
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
            // until coding mapper
            return [League(id: 1, name: "", sport: .Football, country: "", badge: "")]
        }
        
        func removeFavLeague(id: Int) {
            coreData.removeFavorite(leagueId: id)
        }
        
        func isLeagueFavorite(id: Int) -> Bool {
            coreData.isFavorite(leagueId: id)
        }
    }

