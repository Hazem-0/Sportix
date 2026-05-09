//
//  MainTabBarController.swift
//  Sportix
//
//  Created by Aalaa Adel on 08/05/2026.
//


import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupTabBarAppearance()
        setupTabBarItems()
        

    }
    
    private func setupTabBarAppearance() {
        
        tabBar.tintColor = AppTheme.Colors.primary
        tabBar.unselectedItemTintColor = AppTheme.Colors.textSecondary
        tabBar.backgroundColor = AppTheme.Colors.background
        tabBar.isTranslucent = false
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.Colors.background
        
        appearance.stackedLayoutAppearance.selected.iconColor = AppTheme.Colors.primary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: AppTheme.Colors.primary
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = AppTheme.Colors.textSecondary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: AppTheme.Colors.textSecondary
        ]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabBarItems(){
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            guard let navigationController = viewController as? UINavigationController,
                  let rootViewController = navigationController.viewControllers.first else {
                      continue
                  }
            
            if rootViewController is SportsViewController {
                let sportsIcon = UIImage(systemName: "sportscourt")
                let sportsSelectedIcon = UIImage(systemName: "sportscourt.fill")
                
                navigationController.tabBarItem = UITabBarItem(
                    title: "Sports",
                    image: sportsIcon,
                    selectedImage: sportsSelectedIcon
                )
            }
            
            if rootViewController is FavoriteViewController {
                let favoritesIcon = UIImage(systemName: "star")
                let favoritesSelectedIcon = UIImage(systemName: "star.fill")
                
                navigationController.tabBarItem = UITabBarItem(
                    title: "Favorites",
                    image: favoritesIcon,
                    selectedImage: favoritesSelectedIcon
                )
            }
        }
        
    }

}
