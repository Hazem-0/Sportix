//
//  FavoritesPresnter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import Foundation

protocol FavoritesPresenter {
    func viewDidLoad()
    func viewWillAppear()
    func didTapDeleteLeague(at index: Int)
    func confirmDeleteLeague(at index: Int)
    func didSelectLeague(at index: Int)
}

class FavoritesPresenterImp: FavoritesPresenter {
    private weak var view: FavoritesView?
    private let repository: SportixRepo
    private var leagues: [League] = []
    
    init(view: FavoritesView, repository: SportixRepo = SportixRepoImp()) {
        self.view = view
        self.repository = repository
    }
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        leagues = repository.getAllFavoriteLeagues()
        if leagues.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showFavorites(leagues)
        }
    }
    
    func didTapDeleteLeague(at index: Int) {
        let league = leagues[index]
        view?.showDeleteConfirmation(leagueName: league.name, index: index)
    }
    
    func confirmDeleteLeague(at index: Int) {
        let league = leagues[index]
        repository.removeFavLeague(id: league.id)
        leagues.remove(at: index)
        
        if leagues.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showFavorites(leagues)
        }
    }
    
    func didSelectLeague(at index: Int) {
        let league = leagues[index]
        view?.navigateToDetails(for: league)
    }
}
