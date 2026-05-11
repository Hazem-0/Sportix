//
//  LeagueResponse+Mapping.swift
//  Sportix
//
//  Created by Aalaa Adel on 10/05/2026.
//

import Foundation

extension LeagueResponse {
    
    func toLeague(sport: Sport) -> League? {
        guard let id = league_key,
              let name = league_name,
              !name.isEmpty else {
            return nil
        }
        
        return League(
            id: id,
            name: name,
            sport: sport,
            country: country_name ?? "Unknown",
            badge: league_logo ?? ""
        )
    }
}
