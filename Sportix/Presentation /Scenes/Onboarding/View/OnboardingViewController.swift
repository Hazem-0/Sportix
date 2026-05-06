//
//  OnboardingViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 05/05/2026.
//

import UIKit

final class OnboardingViewController: UIPageViewController {

    private let appRepository: AppRepositoryProtocol = AppRepository()

    private lazy var presenter: OnboardingPresenter = {
        let presenter = OnboardingPresenter(
            appRepository: appRepository
        )
        presenter.view = self
        return presenter
    }()

    private let pageIdentifiers = [
        "FirstOnboardingViewController",
        "SecondOnboardingViewController",
        "ThirdOnboardingViewController"
    ]

    private lazy var pages: [OnboardingContentViewController] = {
        return pageIdentifiers.enumerated().compactMap { index, identifier in

            guard let controller = storyboard?.instantiateViewController(
                withIdentifier: identifier
            ) as? OnboardingContentViewController else {
                print("Failed to create page:", identifier)
                return nil
            }

            controller.slide = presenter.slide(at: index)
            controller.pageIndex = index
            controller.totalPages = presenter.numberOfSlides
            controller.delegate = self

            return controller
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        presenter.viewDidLoad()
    }

    private func setupPageViewController() {
        dataSource = self
        delegate = self

        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func navigateToMainTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let tabBarController = storyboard.instantiateViewController(
            withIdentifier: "MainTabBarController"
        )

        guard let window = view.window else {
            navigationController?.setViewControllers(
                [tabBarController],
                animated: true
            )
            return
        }

        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = tabBarController
            }
        )
    }
}

extension OnboardingViewController: OnboardingViewProtocol {

    func showPage(index: Int, direction: OnboardingDirection) {
        guard index >= 0, index < pages.count else {
            print("Invalid page index or pages are empty")
            return
        }

        let navigationDirection: UIPageViewController.NavigationDirection

        switch direction {
        case .forward:
            navigationDirection = .forward
        case .reverse:
            navigationDirection = .reverse
        case .none:
            navigationDirection = .forward
        }

        setViewControllers(
            [pages[index]],
            direction: navigationDirection,
            animated: direction != .none,
            completion: nil
        )
    }

    func finishOnboarding() {
        navigateToMainTabBar()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let currentPage = viewController as? OnboardingContentViewController else {
            return nil
        }

        let previousIndex = currentPage.pageIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let currentPage = viewController as? OnboardingContentViewController else {
            return nil
        }

        let nextIndex = currentPage.pageIndex + 1

        guard nextIndex < pages.count else {
            return nil
        }

        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let visiblePage = viewControllers?.first as? OnboardingContentViewController else {
            return
        }

        presenter.didSwipeToPage(index: visiblePage.pageIndex)
    }
}

extension OnboardingViewController: OnboardingContentDelegate {

    func didTapNext() {
        presenter.didTapNext()
    }

    func didTapSkip() {
        presenter.didTapSkip()
    }
}
