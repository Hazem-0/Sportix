//
//  PlayerResponse.swift
//  Sportix
//
//  Created by Aalaa Adel on 11/05/2026.
//

import Foundation

struct PlayerResponse: Decodable {
    let player_key: Int?
    let player_image: String?
    let player_name: String?
    let player_number: String?
    let player_type: String?
    let player_injured: String?
}
