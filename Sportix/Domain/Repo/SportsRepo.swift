//
//  SportsRepo.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 06/05/2026.
//

import Foundation

protocol SportsRepo {
    
    func saveFavLeague(league : League)
    func getAllFavoriteLeagues() -> [League]
    func removeFavLeague (id : Int)
    func isLeagueFavorite(id :Int ) -> Bool
    
    
}
