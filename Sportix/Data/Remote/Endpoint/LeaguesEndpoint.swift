//
//  LeaguesEndpoint.swift
//  Sportix
//
//  Created by Aalaa Adel on 10/05/2026.
//

import Foundation
import Alamofire

struct LeaguesEndpoint: NetworkEndpoint {
    
    let sport: Sport
    
    var path: String {
        return "/\(sport.apiPath)/"
    }
    
    var parameters: Parameters {
        return [
            "met": "Leagues",
            "APIkey": API.apiKey
        ]
    }
}
