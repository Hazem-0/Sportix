//
//  OnboardingContentViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 05/05/2026.
//
import UIKit

protocol OnboardingContentDelegate: AnyObject {
    func didTapNext()
    func didTapSkip()
}

final class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var gradientOverlayView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var actionButton: UIButton!

    
    weak var delegate: OnboardingContentDelegate?

    var slide: OnboardingSlide?
    var pageIndex: Int = 0
    var totalPages: Int = 0

    private let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupGradient()
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background

        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = AppTheme.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = AppTheme.Colors.textSecondary
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        pageControl.numberOfPages = totalPages
        pageControl.currentPage = pageIndex
        pageControl.currentPageIndicatorTintColor = AppTheme.Colors.primary
        pageControl.pageIndicatorTintColor = AppTheme.Colors.pageIndicator

        actionButton.backgroundColor = AppTheme.Colors.primary
        actionButton.setTitleColor(AppTheme.Colors.onPrimary, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(AppTheme.Colors.onPrimary, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    private func configure() {
        guard let slide = slide else { return }

        heroImageView.image = UIImage(named: slide.imageName)
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description

        let isLastPage = pageIndex == totalPages - 1

        actionButton.setTitle(isLastPage ? "Get Started" : "Next", for: .normal)
        skipButton.isHidden = isLastPage
    }

    private func setupGradient() {
        gradientLayer.frame = gradientOverlayView.bounds

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            AppTheme.Colors.background.cgColor
        ]

        gradientLayer.locations = [0.0, 1.0]

        if gradientLayer.superlayer == nil {
            gradientOverlayView.layer.addSublayer(gradientLayer)
        }
    }

    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        delegate?.didTapNext()
    }

    @IBAction func skipButtonTapped(_ sender: UIButton) {
        delegate?.didTapSkip()
    }
}
