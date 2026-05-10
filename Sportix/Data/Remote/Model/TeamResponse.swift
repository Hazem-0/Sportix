//
//  TeamResponse.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Foundation


struct TeamResponse: Decodable {
    let team_key: Int?
    let team_name: String?
    let team_logo: String?
    let team_country: String?
    let team_founded: String?
}
