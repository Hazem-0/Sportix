//
//  OnboardingPresenter.swift
//  Sportix
//
//  Created by Aalaa Adel on 05/05/2026.
//

import Foundation

enum OnboardingDirection {
    case forward
    case reverse
    case none
}

protocol OnboardingViewProtocol: AnyObject {
    func showPage(index: Int, direction: OnboardingDirection)
    func finishOnboarding()
}

final class OnboardingPresenter {

    weak var view: OnboardingViewProtocol?

    private let appRepository: AppRepositoryProtocol
    private var currentIndex = 0

    private let slides: [OnboardingSlide] = [
        OnboardingSlide(
            imageName: "onboarding_discover",
            title: "Discover Sports",
            description: "Explore different sports categories and find the leagues you love."
        ),
        OnboardingSlide(
            imageName: "onboarding_events",
            title: "Stay Updated",
            description: "Follow your favorite leagues and teams in real-time."
        ),
        OnboardingSlide(
            imageName: "onboarding_favorites",
            title: "Save Favorites",
            description: "Keep your favorite leagues saved for quick and easy access."
        )
    ]

    init(appRepository: AppRepositoryProtocol) {
        self.appRepository = appRepository
    }

    var numberOfSlides: Int {
        return slides.count
    }

    func slide(at index: Int) -> OnboardingSlide {
        return slides[index]
    }

    func viewDidLoad() {
        view?.showPage(index: currentIndex, direction: .none)
    }

    func didTapNext() {
        let isLastPage = currentIndex == slides.count - 1

        if isLastPage {
            appRepository.markOnboardingAsSeen()
            view?.finishOnboarding()
            return
        }

        currentIndex += 1
        view?.showPage(index: currentIndex, direction: .forward)
    }

    func didTapSkip() {
        appRepository.markOnboardingAsSeen()
        view?.finishOnboarding()
    }

    func didSwipeToPage(index: Int) {
        currentIndex = index
    }
}
