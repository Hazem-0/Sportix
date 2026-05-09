//
//  LeaguesViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//


import UIKit

final class LeaguesViewController: UITableViewController {

    var sport: Sport!

    private var presenter: LeaguesPresenter!
    private var leagues: [League] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPresenter()
        setupUI()
        setupTableView()

        presenter.viewDidLoad()
    }

    private func setupPresenter() {
        presenter = LeaguesPresenter(sport: sport)
        presenter.view = self
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background
        tableView.backgroundColor = AppTheme.Colors.background

        setupNavigationTitle()
        setupBackButton()
    }

    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Leagues"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = AppTheme.Colors.textPrimary
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = sport.displayName
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = AppTheme.Colors.primary
        subtitleLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center

        navigationItem.titleView = stackView
    }

    private func setupBackButton() {
        navigationController?.navigationBar.tintColor = AppTheme.Colors.primary
    }

    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 78
        tableView.tableFooterView = UIView()

        let nib = UINib(
            nibName: LeagueTableViewCell.identifier,
            bundle: nil
        )

        tableView.register(
            nib,
            forCellReuseIdentifier: LeagueTableViewCell.identifier
        )
    }

    private func showMessageInTableBackground(_ message: String) {
        let label = UILabel()
        label.text = message
        label.textColor = AppTheme.Colors.textSecondary
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0

        tableView.backgroundView = label
    }

    private func hideTableBackgroundMessage() {
        tableView.backgroundView = nil
    }
}

extension LeaguesViewController: LeaguesViewProtocol {

    func showLeagues(_ leagues: [League]) {
        self.leagues = leagues
        hideTableBackgroundMessage()
        tableView.reloadData()
    }
}

extension LeaguesViewController {

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return leagues.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LeagueTableViewCell.identifier,
            for: indexPath
        ) as? LeagueTableViewCell else {
            return UITableViewCell()
        }

        let league = leagues[indexPath.row]
        cell.configure(with: league)

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let selectedLeague = leagues[indexPath.row]
        print("Selected League:", selectedLeague.name)
        
    }
}
