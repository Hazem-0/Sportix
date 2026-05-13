//
//  AppSettingsLocalDataSource.swift
//  Sportix
//
//  Created by Aalaa Adel on 06/05/2026.
//

import Foundation


protocol AppSettingsLocalDataSourceProtocol {
    func hasSeenOnboarding() -> Bool
    func markOnboardingAsSeen()
    func getSavedTheme() ->Int
    func saveTheme(themeType : Int)

}


final class AppSettingsLocalDataSource: AppSettingsLocalDataSourceProtocol {
    
    func getSavedTheme() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.appTheme)
    }
    
    func saveTheme(themeType: Int) {
        UserDefaults.standard.set(themeType, forKey: Keys.appTheme)
    }
    

    private enum Keys {
          static let hasSeenOnboarding = "hasSeenOnboarding"
        static let appTheme = "selectedTheme"
      }

      func hasSeenOnboarding() -> Bool {
          return UserDefaults.standard.bool(forKey: Keys.hasSeenOnboarding)
      }

      func markOnboardingAsSeen() {
          UserDefaults.standard.set(true, forKey: Keys.hasSeenOnboarding)
      }
}
