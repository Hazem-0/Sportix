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
        static let primary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.376, green: 0.647, blue: 0.980, alpha: 1.0) // Stadium Sky Blue - #60A5FA
            : UIColor(red: 0.145, green: 0.388, blue: 0.922, alpha: 1.0) // Royal Sport Blue - #2563EB
        }

        // Extra accent for highlights, icons, selected states
        static let accent = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.133, green: 0.827, blue: 0.933, alpha: 1.0) // Neon Aqua - #22D3EE
            : UIColor(red: 0.024, green: 0.714, blue: 0.831, alpha: 1.0) // Sport Cyan - #06B6D4
        }

        // Text on primary buttons
        static let onPrimary = UIColor.white

        // Screen backgrounds
        static let background = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.008, green: 0.024, blue: 0.090, alpha: 1.0) // Midnight Arena - #020617
            : UIColor(red: 0.973, green: 0.980, blue: 0.988, alpha: 1.0) // Ice White - #F8FAFC
        }

        // Cards and cells
        static let card = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.059, green: 0.090, blue: 0.165, alpha: 1.0) // Navy Card - #0F172A
            : UIColor.white
        }

        // Text colors
        static let textPrimary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.973, green: 0.980, blue: 0.988, alpha: 1.0) // Ice Text - #F8FAFC
            : UIColor(red: 0.059, green: 0.090, blue: 0.165, alpha: 1.0) // Deep Navy Text - #0F172A
        }

        static let textSecondary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.796, green: 0.835, blue: 0.882, alpha: 1.0) // Cool Silver Text - #CBD5E1
            : UIColor(red: 0.392, green: 0.455, blue: 0.545, alpha: 1.0) // Slate Text - #64748B
        }

        // Borders / separators
        static let border = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.118, green: 0.161, blue: 0.231, alpha: 1.0) // Dark Steel Border - #1E293B
            : UIColor(red: 0.886, green: 0.910, blue: 0.941, alpha: 1.0) // Soft Border - #E2E8F0
        }

        // Page control
        static let pageIndicator = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.278, green: 0.333, blue: 0.412, alpha: 1.0) // Muted Navy Indicator - #475569
            : UIColor(red: 0.796, green: 0.835, blue: 0.882, alpha: 1.0) // Light Silver Indicator - #CBD5E1
        }

        // Favorite star
        static let favorite = UIColor(red: 0.961, green: 0.620, blue: 0.043, alpha: 1.0) // Trophy Gold - #F59E0B

        // Error / offline
        static let error = UIColor(red: 0.937, green: 0.267, blue: 0.267, alpha: 1.0) // Clean Match Red - #EF4444

        // Success / online
        static let success = UIColor(red: 0.133, green: 0.773, blue: 0.369, alpha: 1.0) // Pitch Green - #22C55E
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
