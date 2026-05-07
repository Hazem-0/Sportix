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
        view.backgroundColor = .systemBackground

        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true

        gradientOverlayView.backgroundColor = .clear

        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        pageControl.numberOfPages = totalPages
        pageControl.currentPage = pageIndex
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray4

        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.systemBlue, for: .normal)
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
            UIColor.systemBackground.cgColor
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
