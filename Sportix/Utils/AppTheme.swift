//
//  AppTheme.swift
//  Sportix
//
//  Created by Aalaa Adel on 05/05/2026.
//

import UIKit

enum AppTheme {

    enum Colors {
        // Main app color
        static let primary = UIColor.systemBlue
        
        // Text on primary buttons
        static let onPrimary = UIColor.white

        // Screen backgrounds
        static let background = UIColor.systemBackground

        // Cards and cells
        static let card = UIColor.secondarySystemBackground
        
        // Text colors
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel

        // Borders / separators
        static let border = UIColor.separator
        
        // Page control
        static let pageIndicator = UIColor.systemGray4
        
        // Favorite star
        static let favorite = UIColor.systemYellow

        // Error / offline
        static let error = UIColor.systemRed
        
        // Success / online
        static let success = UIColor.systemGreen
    }

    enum Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
    }

    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
}
