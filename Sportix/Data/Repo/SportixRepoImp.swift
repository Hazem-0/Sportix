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
            if(coreData.fetchAllFavorites().isEmpty){
            return [League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png"),
    ]
            }
            let leagues = coreData.fetchAllFavorites().map{
                entity in
                return entity.toLeague()
            }
            return leagues
        }
        
        func removeFavLeague(id: Int) {
            coreData.removeFavorite(leagueId: id)
        }
        
        func isLeagueFavorite(id: Int) -> Bool {
            coreData.isFavorite(leagueId: id)
        }
    }

