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

}


final class AppSettingsLocalDataSource: AppSettingsLocalDataSourceProtocol {

    private enum Keys {
          static let hasSeenOnboarding = "hasSeenOnboarding"
      }

      func hasSeenOnboarding() -> Bool {
          return UserDefaults.standard.bool(forKey: Keys.hasSeenOnboarding)
      }

      func markOnboardingAsSeen() {
          UserDefaults.standard.set(true, forKey: Keys.hasSeenOnboarding)
      }
}
