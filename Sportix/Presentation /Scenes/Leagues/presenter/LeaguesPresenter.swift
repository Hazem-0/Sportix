//
//  LeaguesPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//



import Foundation

protocol LeaguesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func refresh()

    func getSportName() -> String
    func getLeaguesCount() -> Int
    func getLeague(at index: Int) -> League?

    func didSelectLeague(at index: Int)
}


final class LeaguesPresenter: LeaguesPresenterProtocol {

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

    func getSportName() -> String {
        return sport.displayName
    }

    func getLeaguesCount() -> Int {
        return leagues.count
    }

    func getLeague(at index: Int) -> League? {
        guard index >= 0, index < leagues.count else {
            return nil
        }

        return leagues[index]
    }

    func didSelectLeague(at index: Int) {
        guard let selectedLeague = getLeague(at: index) else {
            return
        }

        view?.navigateToLeagueDetails(
            league : selectedLeague
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
                        self.view?.reloadData()
                    }
                }

            } catch {
                if Task.isCancelled {
                    return
                }

                print("Leagues Error Full:", error)
                print("Leagues Error Description:", error.localizedDescription)

                self.leagues = []

                await MainActor.run {
                    self.view?.hideLoading()
                    self.view?.showErrorMessage("Couldn't load leagues. Please try again.")
                }
            }
        }
    }
}
