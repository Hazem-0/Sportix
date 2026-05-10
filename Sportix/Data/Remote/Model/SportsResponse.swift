//
//  SportsResponse.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Foundation


struct SportsResonse<T: Decodable>: Decodable {
    let success: Int?
    let result: T?
}
