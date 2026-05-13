//
//  PlayerResponse+Mapping.swift
//  Sportix
//
//  Created by Aalaa Adel on 11/05/2026.
//

import Foundation

extension PlayerResponse {
    
    func toDomain() -> Player? {
        guard let image = player_image?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !image.isEmpty,
              image.lowercased().hasPrefix("http") else {
            return nil
        }
        
        return Player(
            imageName: image,
            number: player_number?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            name: player_name ?? "Unknown Player",
            position: player_type ?? "Unknown",
            isInjured: (player_injured ?? "").lowercased() == "yes"
        )
    }
}
