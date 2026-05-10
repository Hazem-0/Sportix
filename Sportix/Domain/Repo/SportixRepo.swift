//
//  SportsRepo.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 06/05/2026.
//

import Foundation

protocol SportixRepo {
    
    func saveFavLeague(league : League)
    func getAllFavoriteLeagues() -> [League]
    func removeFavLeague (id : Int)
    func isLeagueFavorite(id :Int ) -> Bool
    func hasSeenOnboarding() -> Bool
    func markOnboardingAsSeen()
    func getLeagues(for sport: Sport) async throws -> [League]
    
}
