//
//  FavEntity+Mapping.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 09/05/2026.
//

import Foundation
import CoreData

extension FavLeague {
    func toLeague() -> League {
        let sportType: Sport
        
        switch self.sport {
        case 0:
            sportType = .Football
        case 1:
            sportType = .BasketBall
        case 2:
            sportType = .Tennis
        case 3:
            sportType = .Cricket
        default:
            sportType = .Football
        }
        
        return League(
            id: Int(self.id),
            name: self.name ?? "",
            sport: sportType,
            country: self.country ?? "",
            badge: self.badge ?? ""
        )
    }
}

extension League {
    func toEntity(in context: NSManagedObjectContext) -> FavLeague {
        let entity = FavLeague(context: context)
        entity.id = Int64(self.id)
        entity.name = self.name
        entity.country = self.country
        entity.badge = self.badge
        
        let sportValue: Int16
        switch self.sport {
        case .Football:
            sportValue = 0
        case .BasketBall:
            sportValue = 1
        case .Tennis:
            sportValue = 2
        case .Cricket:
            sportValue = 3
        }
        entity.sport = sportValue
        
        return entity
    }
}
