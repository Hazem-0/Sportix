//
//  LeagueResponse+Mapping.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
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
        )
    }
}
