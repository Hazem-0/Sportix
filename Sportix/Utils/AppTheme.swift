//
//  AppTheme.swift
//  Sportix
//
//  Created by Aalaa Adel on 05/05/2026.
//

import UIKit

enum AppTheme {

    enum Colors {
        static let primary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.376, green: 0.647, blue: 0.980, alpha: 1.0)
            : UIColor(red: 0.145, green: 0.388, blue: 0.922, alpha: 1.0)
        }

        static let accent = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.133, green: 0.827, blue: 0.933, alpha: 1.0)
            : UIColor(red: 0.024, green: 0.714, blue: 0.831, alpha: 1.0)
        }

        static let onPrimary = UIColor.white

        static let background = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.008, green: 0.024, blue: 0.090, alpha: 1.0)
            : UIColor(red: 0.973, green: 0.980, blue: 0.988, alpha: 1.0)
        }

        static let card = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.059, green: 0.090, blue: 0.165, alpha: 1.0)
            : UIColor.secondarySystemBackground
        }

        static let textPrimary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.973, green: 0.980, blue: 0.988, alpha: 1.0)
            : UIColor(red: 0.059, green: 0.090, blue: 0.165, alpha: 1.0)
        }

        static let textSecondary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.796, green: 0.835, blue: 0.882, alpha: 1.0)
            : UIColor(red: 0.392, green: 0.455, blue: 0.545, alpha: 1.0)
        }

        static let border = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.118, green: 0.161, blue: 0.231, alpha: 1.0)
            : UIColor(red: 0.886, green: 0.910, blue: 0.941, alpha: 1.0)
        }

        static let pageIndicator = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.278, green: 0.333, blue: 0.412, alpha: 1.0)
            : UIColor(red: 0.796, green: 0.835, blue: 0.882, alpha: 1.0)
        }

        static let favorite = UIColor(red: 0.961, green: 0.620, blue: 0.043, alpha: 1.0)

        static let error = UIColor(red: 0.937, green: 0.267, blue: 0.267, alpha: 1.0)

        static let success = UIColor(red: 0.133, green: 0.773, blue: 0.369, alpha: 1.0)
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


extension AppTheme {
    enum ThemeManager {

        static func applySavedTheme(to window: UIWindow?, repo: SportixRepo) {
            let savedStyleInt = repo.getSavedTheme()
            if savedStyleInt != 0, let style = UIUserInterfaceStyle(rawValue: savedStyleInt) {
                window?.overrideUserInterfaceStyle = style
            }
        }

        static func toggle(in window: UIWindow?, currentTrait: UIUserInterfaceStyle, repo: SportixRepo) -> UIImage? {
            let currentStyle = window?.overrideUserInterfaceStyle == .unspecified ? currentTrait : (window?.overrideUserInterfaceStyle ?? currentTrait)
            let newStyle: UIUserInterfaceStyle = (currentStyle == .dark) ? .light : .dark
            
            repo.saveTheme(themeType: newStyle.rawValue)
            
            if let window = window {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.overrideUserInterfaceStyle = newStyle
                }, completion: nil)
            }
            
            return getIcon(for: newStyle)
        }

        static func currentIcon(in window: UIWindow?, currentTrait: UIUserInterfaceStyle) -> UIImage? {
            let currentStyle = window?.overrideUserInterfaceStyle == .unspecified ? currentTrait : (window?.overrideUserInterfaceStyle ?? currentTrait)
            return getIcon(for: currentStyle)
        }

        private static func getIcon(for style: UIUserInterfaceStyle) -> UIImage? {
            let iconName = (style == .dark) ? "sun.max.fill" : "moon.fill"
            return UIImage(systemName: iconName)
        }
    }
}
