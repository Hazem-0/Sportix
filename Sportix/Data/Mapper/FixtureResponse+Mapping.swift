//
//  FixtureResponse+Mapping.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import Foundation

extension FixtureResponse {
    func toDomain() -> Fixture {
        
        let scoreString = self.event_final_result ?? "-"
        let scoreArray = scoreString.components(separatedBy: " - ")
        let homeScore = scoreArray.first ?? ""
        let awayScore = scoreArray.count > 1 ? scoreArray[1] : ""
        
        return Fixture(
            id: self.event_key ?? 0,
            date: self.event_date ?? "TBD",
            time: self.event_time ?? "TBD",
            homeTeamName: self.event_home_team ?? "TBD",
            awayTeamName: self.event_away_team ?? "TBD",
            homeTeamScore: homeScore,
            awayTeamScore: awayScore,
            homeTeamLogo: self.home_team_logo ?? "",
            awayTeamLogo: self.away_team_logo ?? "",
            isLive: false
        )
    }
}
