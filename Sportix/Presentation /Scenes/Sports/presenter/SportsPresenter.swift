//
//  SportsPresenter.swift
//  Sportix
//
//  Created by Aalaa Adel on 07/05/2026.
//


import Foundation

protocol SportsViewProtocol : AnyObject {
    func showSports(_ sports: [Sport])
    func navigateToLeagues(with sport: Sport)
}

final class SportsPresenter {

    weak var view: SportsViewProtocol?

    private var sports: [Sport] = []

    func viewDidLoad() {
        sports = Sport.allSports
        view?.showSports(sports)
    }

    func didSelectSport(at index: Int) {
        guard index >= 0, index < sports.count else { return }

        let selectedSport = sports[index]
        view?.navigateToLeagues(with: selectedSport)
    }
}
