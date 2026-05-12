//
//  TeamDetailsPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import Foundation

protocol TeamDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()

    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int) -> Int

    func getTeamDetails() -> TeamDetails?
    func getPlayer(at row: Int) -> Player?

    func didSelectRow(section: Int, row: Int)
}

final class TeamDetailsPresenter: TeamDetailsPresenterProtocol {

    weak var view: TeamDetailsViewProtocol?

    private let sport: Sport
    private let teamId: Int
    private let repo: SportixRepo

    private var team: TeamDetails?
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

    func getNumberOfSections() -> Int {
        return team == nil ? 0 : 2
    }

    func getNumberOfRows(in section: Int) -> Int {
        guard let team = team else {
            return 0
        }

        if section == 0 {
            return 1
        }

        return team.players.count + 1
    }

    func getTeamDetails() -> TeamDetails? {
        return team
    }

    func getPlayer(at row: Int) -> Player? {
        guard let team = team else {
            return nil
        }

        let playerIndex = row - 1

        guard playerIndex >= 0,
              playerIndex < team.players.count else {
            return nil
        }

        return team.players[playerIndex]
    }

    func didSelectRow(section: Int, row: Int) {
        guard section == 1,
              row > 0,
              let selectedPlayer = getPlayer(at: row) else {
            return
        }

        print("Selected player:", selectedPlayer.name)
    }

    private func loadTeamDetails() {
        loadTask?.cancel()

        loadTask = Task { [weak self] in
            guard let self = self else { return }

            await MainActor.run {
                self.view?.showLoading()
            }

            do {
                let fetchedTeam = try await self.repo.fetchTeamDetails(
                    sport: self.sport,
                    teamId: self.teamId
                )

                if Task.isCancelled {
                    return
                }

                self.team = fetchedTeam

                await MainActor.run {
                    self.view?.hideLoading()
                    self.view?.reloadData()
                }

            } catch {
                if Task.isCancelled {
                    return
                }

                print("Team Details Error Full:", error)
                print("Team Details Error Description:", error.localizedDescription)

                self.team = nil

                await MainActor.run {
                    self.view?.hideLoading()
                    self.view?.showErrorMessage("Couldn't load team details. Please try again.")
                }
            }
        }
    }
}
