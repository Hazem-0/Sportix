//
//  TeamDetailsViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

final class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var presenter: TeamDetailsPresenter!
    private var team: TeamDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPresenter()
        setupUI()
        setupTableView()

        presenter.viewDidLoad()
    }

    private func setupPresenter() {
        presenter = TeamDetailsPresenter()
        presenter.view = self
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = AppTheme.Colors.textPrimary

        navigationItem.title = ""

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = AppTheme.Colors.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()

        registerCells()

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    private func registerCells() {
        let headerNib = UINib(
            nibName: TeamHeaderTableViewCell.identifier,
            bundle: nil
        )

        tableView.register(
            headerNib,
            forCellReuseIdentifier: TeamHeaderTableViewCell.identifier
        )

        let titleNib = UINib(
            nibName: SquadTitleTableViewCell.identifier,
            bundle: nil
        )

        tableView.register(
            titleNib,
            forCellReuseIdentifier: SquadTitleTableViewCell.identifier
        )

        let playerNib = UINib(
            nibName: SquadPlayerTableViewCell.identifier,
            bundle: nil
        )

        tableView.register(
            playerNib,
            forCellReuseIdentifier: SquadPlayerTableViewCell.identifier
        )
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func favoriteButtonTapped() {
        print("Favorite tapped")
    }
}


extension TeamDetailsViewController: TeamDetailsViewProtocol {

    func showTeamDetails(_ team: TeamDetails) {
        self.team = team
        tableView.reloadData()
    }
}


extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return team == nil ? 0 : 2
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let team = team else {
            return 0
        }

        if section == 0 {
            return 1
        }

        return team.players.count + 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let team = team else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TeamHeaderTableViewCell.identifier,
                for: indexPath
            ) as? TeamHeaderTableViewCell else {
                return UITableViewCell()
            }

            cell.configure(with: team)
            return cell
        }

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SquadTitleTableViewCell.identifier,
                for: indexPath
            ) as? SquadTitleTableViewCell else {
                return UITableViewCell()
            }

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SquadPlayerTableViewCell.identifier,
            for: indexPath
        ) as? SquadPlayerTableViewCell else {
            return UITableViewCell()
        }

        let player = team.players[indexPath.row - 1]
        cell.configure(with: player)

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        }

        if indexPath.row == 0 {
            return 64
        }

        return 96
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard indexPath.section == 1,
              indexPath.row > 0,
              let team = team else {
            return
        }

        let selectedPlayer = team.players[indexPath.row - 1]
        print("Selected player:", selectedPlayer.name)
    }
}
