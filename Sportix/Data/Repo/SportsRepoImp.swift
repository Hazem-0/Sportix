//
//  SportsRepoImp.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 06/05/2026.
//

import Foundation

class SportsRepoImp : SportsRepo{
    
    private let localDataSource: CoreDataManager
    
    init(localDataSource: CoreDataManager = CoreDataManager.shared) {
            self.localDataSource = localDataSource
        }
    
    func saveFavLeague(league: League) {
            // Alaa Code
    }
    
    func getAllFavoriteLeagues() -> [League] {
        return [League(id:1,name:"",sport: .Football , country: "" ,badge: "")]
        //until coding mapper
    }
    
    func removeFavLeague(id: Int) {
        localDataSource.removeFavorite(leagueId: id)
    }
    
    func isLeagueFavorite(id: Int) -> Bool {
        // Alaa Code
        return false
    }
    
    
 
    
    
}
