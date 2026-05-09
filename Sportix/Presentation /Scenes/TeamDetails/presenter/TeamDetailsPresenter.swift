//
//  TeamDetailsPresenter.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import Foundation

protocol TeamDetailsViewProtocol: AnyObject {
    func showTeamDetails(_ team: TeamDetails)
}

final class TeamDetailsPresenter {

    weak var view: TeamDetailsViewProtocol?

    func viewDidLoad() {
        let team = getStaticTeamDetails()
        view?.showTeamDetails(team)
    }

    private func getStaticTeamDetails() -> TeamDetails {
        return TeamDetails(
            name: "Juventus FC",
            country: "Italy",
            countryFlag: "🇮🇹",
            logoName: "sport_basketball",
            players: [
                Player(
                    imageName: "sport_cricket",
                    number: "16",
                    name: "Michele Di Gregorio",
                    position: "Goalkeeper",
                    isInjured: false
                ),
                Player(
                    imageName: "sport_cricket",
                    number: "3",
                    name: "Bremer",
                    position: "Defender",
                    isInjured: false
                ),
                Player(
                    imageName: "sport_cricket",
                    number: "24",
                    name: "Danilo",
                    position: "Defender",
                    isInjured: false
                ),
                Player(
                    imageName: "sport_cricket",
                    number: "11",
                    name: "Douglas Costa",
                    position: "Midfielder",
                    isInjured: true
                ),
                Player(
                    imageName: "sport_cricket",
                    number: "5",
                    name: "Manuel Locatelli",
                    position: "Midfielder",
                    isInjured: false
                ),
                Player(
                    imageName: "sport_cricket",
                    number: "7",
                    name: "Federico Chiesa",
                    position: "Forward",
                    isInjured: false
                ),
                Player(
                    imageName: "sport_cricket",
                    number: "9",
                    name: "Dušan Vlahović",
                    position: "Forward",
                    isInjured: false
                ),
                Player(
                    imageName: "sport_cricket",
                    number: "16",
                    name: "Weston McKennie",
                    position: "Midfielder",
                    isInjured: false
                )
            ]
        )
    }
}
