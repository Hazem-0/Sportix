//
//  FixtureEndpoint.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import Foundation
import Alamofire

struct FixturesEndpoint: NetworkEndpoint {
    let sport: String
    let leagueId: Int
    let upcoming: Bool

    private var dateRange: (from: String, to: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let other = Calendar.current.date(byAdding: .year, value: upcoming ? 1 : -1, to: today)!
        return upcoming
            ? (formatter.string(from: today), formatter.string(from: other))
            : (formatter.string(from: other), formatter.string(from: today))
    }

    var path: String { "/\(sport)/" }
    var parameters: Parameters {
        [
            "met": "Fixtures",
            "leagueId": leagueId,
            "from": dateRange.from,
            "to": dateRange.to,
            "APIkey": API.apiKey
        ]
    }
}


