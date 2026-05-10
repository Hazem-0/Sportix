//
//  SportResponse.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Foundation

struct SportResponse: Decodable {
    let sport_key: Int?
    let sport_name: String?
    let sport_icon: String?
}
