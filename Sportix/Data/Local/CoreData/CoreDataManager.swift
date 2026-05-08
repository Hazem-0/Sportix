//
//  CoreDataManager.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 06/05/2026.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveFavorite(league: League) {
        // Alaa code
    }
    
    func removeFavorite(leagueId: Int) {
        let fetchRequest: NSFetchRequest<FavLeague> = FavLeague.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", leagueId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let favoriteToDelete = results.first {
                context.delete(favoriteToDelete)
                try context.save()
            }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
    
    func fetchAllFavorites() -> [FavLeague] {
        let fetchRequest: NSFetchRequest<FavLeague> = FavLeague.fetchRequest()
      
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }

    func isFavorite(leagueId: Int) -> Bool {
        // Alaa Code
        return false
    }
}
