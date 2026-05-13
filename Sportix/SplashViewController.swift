//
//  SplashViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 13/05/2026.
//

import UIKit
import SDWebImage

final class SplashViewController: UIViewController {

    @IBOutlet weak var animationImageView: SDAnimatedImageView!
    @IBOutlet weak var appNameLabel: UILabel!

    private let appSettings: AppSettingsLocalDataSourceProtocol = AppSettingsLocalDataSource()

    private let splashDuration: TimeInterval = 7.5

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        showGif()
        navigateAfterDelay()
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background

        animationImageView.contentMode = .scaleAspectFit
        animationImageView.clipsToBounds = true

        appNameLabel.text = "Sportix"
        appNameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        appNameLabel.textColor = AppTheme.Colors.textPrimary
        appNameLabel.textAlignment = .center
    }

    private func showGif() {
        guard let url = Bundle.main.url(
            forResource: "ball_playing",
            withExtension: "gif"
        ) else {
            print("ball_playing.gif not found")
            return
        }

        animationImageView.sd_setImage(with: url)
    }

    private func navigateAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) { [weak self] in
            self?.goToNextScreen()
        }
    }

    private func goToNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let nextViewController: UIViewController

        if appSettings.hasSeenOnboarding() {
            nextViewController = storyboard.instantiateViewController(
                withIdentifier: "MainTabBarController"
            )
        } else {
            nextViewController = storyboard.instantiateViewController(
                withIdentifier: "OnboardingViewController"
            )
        }

        guard let window = view.window else {
            return
        }

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = nextViewController
            }
        )
    }
}
