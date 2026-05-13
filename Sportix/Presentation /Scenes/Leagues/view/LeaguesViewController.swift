//
//  LeaguesViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()

    func reloadData()
    func showEmptyMessage(_ message: String)
    func showErrorMessage(_ message: String)

    func navigateToLeagueDetails(
        league : League
    )
}


final class LeaguesViewController: UITableViewController {

    var sport: Sport!

    private var presenter: LeaguesPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPresenter()
        setupUI()
        setupTableView()

        presenter.viewDidLoad()
    }

    private func setupPresenter() {
        presenter = LeaguesPresenter(
            sport: sport,
            view: self
        )
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
        subtitleLabel.text = presenter.getSportName()
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

        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = AppTheme.Colors.primary
        refreshControl?.addTarget(
            self,
            action: #selector(refreshLeagues),
            for: .valueChanged
        )
    }

    @objc private func refreshLeagues() {
        presenter.refresh()
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


// MARK: - LeaguesViewProtocol

extension LeaguesViewController: LeaguesViewProtocol {

    func showLoading() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = AppTheme.Colors.primary
        spinner.startAnimating()

        tableView.backgroundView = spinner
    }

    func hideLoading() {
        refreshControl?.endRefreshing()
        tableView.backgroundView = nil
    }

    func reloadData() {
        hideTableBackgroundMessage()
        tableView.reloadData()
    }

    func showEmptyMessage(_ message: String) {
        tableView.reloadData()
        showMessageInTableBackground(message)
    }

    func showErrorMessage(_ message: String) {
        tableView.reloadData()
        showMessageInTableBackground(message)
    }

    func navigateToLeagueDetails(
        league : League
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let detailsVC = storyboard.instantiateViewController(
            withIdentifier: "LeagueDetailsViewController"
        ) as? LeagueDetailsViewController else {
            let detailsVC = LeagueDetailsViewController(
                nibName: "LeagueDetailsViewController",
                bundle: nil
            
            )
            detailsVC.league = league
            navigationController?.pushViewController(detailsVC, animated: true)
            return
        }

        detailsVC.league = league
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}



extension LeaguesViewController {

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter.getLeaguesCount()
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

        guard let league = presenter.getLeague(at: indexPath.row) else {
            return UITableViewCell()
        }

        cell.configure(with: league)

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectLeague(at: indexPath.row)
    }
}
