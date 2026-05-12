//
//  TeamEndpoint.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import Alamofire

enum TeamsQuery {
    case league(id: Int)
    case team(id: Int)
}

struct TeamsEndpoint: NetworkEndpoint {
    let sport: Sport
    let query: TeamsQuery

    var path: String { "/\(sport.apiPath)/" }
    var parameters: Parameters {
        var params: Parameters = [
            "met": "Teams",
            "APIkey": API.apiKey
        ]
        
        switch query {
        case .league(let id):
            params["leagueId"] = id
            
        case .team(let id):
            params["teamId"] = id
        }
        
        return params
    }

}
