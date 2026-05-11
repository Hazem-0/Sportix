//
//  FixtureRepsonse.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Foundation

struct FixtureResponse: Decodable {
    let event_key: Int?
    let event_date: String?
    let event_time: String?
    let event_home_team: String?
    let event_away_team: String?
    let event_final_result: String? 
    let home_team_logo: String?
    let away_team_logo: String?
}
