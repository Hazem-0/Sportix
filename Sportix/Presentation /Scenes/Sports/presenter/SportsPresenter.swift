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
    func showNoInternetAlert()
}

final class SportsPresenter {

    weak var view: SportsViewProtocol?
    private let reachability: ReachabilityManager = .shared
    private var sports: [Sport] = []
    
    init(view: SportsViewProtocol
) {
        self.view = view
       
    }

    func viewDidLoad() {
        sports = Sport.allSports
        view?.showSports(sports)
    }

    func didSelectSport(at index: Int) {
        guard index >= 0, index < sports.count else { return }

        let selectedSport = sports[index]
        guard reachability.isConnected else {
                    view?.showNoInternetAlert()
                    return
                }
        view?.navigateToLeagues(with: selectedSport)
            }
        
    }

