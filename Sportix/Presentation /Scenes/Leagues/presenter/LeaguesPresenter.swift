//
//  LeaguesPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//



import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLeagues(_ leagues: [League])
}

final class LeaguesPresenter {

    weak var view: LeaguesViewProtocol?

    private let sport: Sport

    init(sport: Sport) {
        self.sport = sport
    }

    func viewDidLoad() {
        let leagues = getStaticLeagues(for: sport)

        view?.showLeagues(leagues)
        
    }

    private func getStaticLeagues(for sport: Sport) -> [League] {
        switch sport {

        case .Football:
            return [
                League(id: 152, name: "Premier League", sport: .Football, country: "England", badge: "badge_premier_league"),
                League(id: 207, name: "La Liga", sport: .Football, country: "Spain", badge: "badge_laliga"),
                League(id: 205, name: "Serie A", sport: .Football, country: "Italy", badge: "badge_serie_a"),
                League(id: 175, name: "Bundesliga", sport: .Football, country: "Germany", badge: "badge_bundesliga"),
                League(id: 168, name: "Ligue 1", sport: .Football, country: "France", badge: "badge_ligue1"),
                League(id: 332, name: "MLS", sport: .Football, country: "USA", badge: "badge_mls"),
                League(id: 3, name: "Champions League", sport: .Football, country: "Europe", badge: "badge_champions_league")
            ]

        case .BasketBall:
            return [
                League(id: 101, name: "NBA", sport: .BasketBall, country: "USA", badge: ""),
                League(id: 102, name: "EuroLeague", sport: .BasketBall, country: "Europe", badge: ""),
                League(id: 103, name: "Liga ACB", sport: .BasketBall, country: "Spain", badge: "")
            ]

        case .Tennis:
            return [
                League(id: 201, name: "ATP Tour", sport: .Tennis, country: "World", badge: ""),
                League(id: 202, name: "WTA Tour", sport: .Tennis, country: "World", badge: ""),
                League(id: 203, name: "Davis Cup", sport: .Tennis, country: "International", badge: "")
            ]

        case .Cricket:
            return [
                League(id: 301, name: "Indian Premier League", sport: .Cricket, country: "India", badge: ""),
                League(id: 302, name: "Big Bash League", sport: .Cricket, country: "Australia", badge: ""),
                League(id: 303, name: "The Hundred", sport: .Cricket, country: "England", badge: "")
            ]
        }
    }
}
