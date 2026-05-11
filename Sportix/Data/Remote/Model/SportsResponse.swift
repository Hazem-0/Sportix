//
//  SportsResponse.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Foundation


struct SportsResponse<T: Decodable>: Decodable {
    let success: Int?
    let result: T?
    let error: String?
}
