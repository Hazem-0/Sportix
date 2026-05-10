//
//  LeagueResponse.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Foundation

struct LeagueResponse: Decodable {
    let league_key: Int?
    let league_name: String?
    let country_name: String?
    let league_logo: String?
}
