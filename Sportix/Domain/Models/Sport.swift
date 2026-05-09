//
//  Sport.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 06/05/2026.
//

import Foundation


enum Sport {
    case Football
    case BasketBall
    case Tennis
    case Cricket

    static let allSports: [Sport] = [
        .Football,
        .BasketBall,
        .Tennis,
        .Cricket
    ]

    var displayName: String {
        switch self {
        case .Football:
            return "Football"
        case .BasketBall:
            return "Basketball"
        case .Tennis:
            return "Tennis"
        case .Cricket:
            return "Cricket"
    
        }
    }

    var imageName: String {
        switch self {
        case .Football:
            return "sport_football"
        case .BasketBall:
            return "sport_basketball"
        case .Tennis:
            return "sport_tennis"
        case .Cricket:
            return "sport_cricket"
        }
    }
}
