//
//  ApRepository.swift
//  Sportix
//
//  Created by Aalaa Adel on 06/05/2026.

import Foundation

final class AppRepository: AppRepositoryProtocol {

    private let localDataSource: AppSettingsLocalDataSourceProtocol

        init(
            localDataSource: AppSettingsLocalDataSourceProtocol = AppSettingsLocalDataSource()
        ) {
            self.localDataSource = localDataSource
        }

        func hasSeenOnboarding() -> Bool {
            return localDataSource.hasSeenOnboarding()
        }

        func markOnboardingAsSeen() {
            localDataSource.markOnboardingAsSeen()
        }
}
