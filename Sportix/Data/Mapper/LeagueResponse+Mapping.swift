//
//  LeagueResponse+Mapping.swift
//  Sportix
//
//  Created by Aalaa Adel on 10/05/2026.
//

import Foundation

extension LeagueResponse {
    func toDomain(sport: Sport) -> League {
        return League(
            id: self.league_key ?? 0,
            name: self.league_name ?? "Unknown League",
            sport: sport,
            country: self.country_name ?? "Unknown Country",
            badge: self.league_logo ?? "sportscourt.circle"
    
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
