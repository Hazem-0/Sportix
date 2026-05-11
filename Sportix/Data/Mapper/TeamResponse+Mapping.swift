//
//  TeamResponse+Mapping.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import Foundation

extension TeamResponse {
    func toDomain() -> TeamDetails {
        return TeamDetails(
            name: self.team_name ?? "Unknown Team",
            country: self.team_country ?? "Unknown",
            countryFlag: "",
            logoName: self.team_logo ?? "sportscourt.circle",
            players: []
        )
    }
}
