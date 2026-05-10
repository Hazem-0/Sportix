//
//  LeaguesPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//



import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showLeagues(_ leagues: [League])
    func showEmptyMessage(_ message: String)
    func showErrorMessage(_ message: String)
    func navigateToLeagueDetails(leagueId: Int, leagueName: String, sport: Sport)
}

final class LeaguesPresenter {
    
    weak var view: LeaguesViewProtocol?
    
    private let sport: Sport
    private let repo: SportixRepo
    
    private var leagues: [League] = []
    private var loadTask: Task<Void, Never>?
    
    init(
        sport: Sport,
        repo: SportixRepo = SportixRepoImp()
    ) {
        self.sport = sport
        self.repo = repo
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    func viewDidLoad() {
        loadLeagues()
    }
    
    func refresh() {
        loadLeagues()
    }
    
    func didSelectLeague(at index: Int) {
        guard index >= 0, index < leagues.count else {
            return
        }
        
        let selectedLeague = leagues[index]
        
        view?.navigateToLeagueDetails(
            leagueId: selectedLeague.id,
            leagueName: selectedLeague.name,
            sport: selectedLeague.sport
        )
    }
    
    private func loadLeagues() {
        loadTask?.cancel()
        
        loadTask = Task { [weak self] in
            guard let self = self else { return }
            
            await MainActor.run {
                self.view?.showLoading()
            }
            
            do {
                let fetchedLeagues = try await self.repo.getLeagues(for: self.sport)
                
                if Task.isCancelled {
                    return
                }
                
                self.leagues = fetchedLeagues
                
                await MainActor.run {
                    self.view?.hideLoading()
                    
                    if fetchedLeagues.isEmpty {
                        self.view?.showEmptyMessage("No leagues found.")
                    } else {
                        self.view?.showLeagues(fetchedLeagues)
                    }
                }
                
            } catch {
                if Task.isCancelled {
                    return
                }
                
                print("Leagues Error:", error.localizedDescription)
                
                self.leagues = []
                
                await MainActor.run {
                    self.view?.hideLoading()
                    self.view?.showErrorMessage("Couldn't load leagues. Please try again.")
                }
            }
        }
    }
}
