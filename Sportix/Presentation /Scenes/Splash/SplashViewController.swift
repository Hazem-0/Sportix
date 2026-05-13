//
//  SplashViewController.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 13/05/2026.
//

import UIKit
import Lottie

final class SplashViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!

    private let appSettings: AppSettingsLocalDataSourceProtocol = AppSettingsLocalDataSource()
    private var animationView: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLottieAnimation()
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background

        appNameLabel.text = "Sportix"
        appNameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        appNameLabel.textColor = AppTheme.Colors.textPrimary
        appNameLabel.textAlignment = .center
    }

    private func setupLottieAnimation() {
        animationView = LottieAnimationView(name: "splash_animation")
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 250),
            animationView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        animationView.play { [weak self] _ in
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

        guard let window = view.window else { return }

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
