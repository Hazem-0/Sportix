//
//  Sport+APIPath.swift
//  Sportix
//
//  Created by Aalaa Adel on 10/05/2026.
//

import Foundation

extension Sport {
    
    var apiPath: String {
        switch self {
        case .Football:
            return "football"
        case .BasketBall:
            return "basketball"
        case .Tennis:
            return "tennis"
        case .Cricket:
            return "cricket"
        }
    }
}
