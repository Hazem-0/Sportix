//
//  TeamDetailsPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import Foundation

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showTeamDetails(_ team: TeamDetails)
    func showErrorMessage(_ message: String)
}

final class TeamDetailsPresenter {

    weak var view: TeamDetailsViewProtocol?
    
    private let sport: Sport
    private let teamId: Int
    private let repo: SportixRepo
    
    private var loadTask: Task<Void, Never>?
    
    init(
        sport: Sport,
        teamId: Int,
        repo: SportixRepo = SportixRepoImp()
    ) {
        self.sport = sport
        self.teamId = teamId
        self.repo = repo
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    func viewDidLoad() {
        loadTeamDetails()
    }
    
    private func loadTeamDetails() {
        loadTask?.cancel()
        
        loadTask = Task { [weak self] in
            guard let self = self else { return }
            
            await MainActor.run {
                self.view?.showLoading()
            }
            
            do {
                let team = try await self.repo.fetchTeamDetails(
                    sport: self.sport,
                    teamId: self.teamId
                )
                
                if Task.isCancelled {
                    return
                }
                
                await MainActor.run {
                    self.view?.hideLoading()
                    self.view?.showTeamDetails(team)
                }
                
            } catch {
                if Task.isCancelled {
                    return
                }
                
                print("Team Details Error:", error.localizedDescription)
                
                await MainActor.run {
                    self.view?.hideLoading()
                    self.view?.showErrorMessage("Couldn't load team details. Please try again.")
                }
            }
        }
    }
}
