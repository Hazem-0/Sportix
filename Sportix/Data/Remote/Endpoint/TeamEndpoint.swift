//
//  TeamEndpoint.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import Alamofire

struct TeamsEndpoint: NetworkEndpoint {
    let sport: String
    let leagueId: Int

    var path: String { "/\(sport)/" }
    var parameters: Parameters {
        ["met": "Teams", "leagueId": leagueId, "APIkey": API.apiKey]
    }
}
