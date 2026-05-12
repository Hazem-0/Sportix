//
//  LeaguesViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//


import UIKit

final class LeaguesViewController: UITableViewController, LeaguesViewProtocol {
    
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
        title = "Leagues"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppTheme.Colors.textPrimary,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
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
    
    func showLeagues(_ leagues: [League]) {
        self.leagues = leagues
        hideTableBackgroundMessage()
        tableView.reloadData()
    }
    
    func showEmptyMessage(_ message: String) {
        leagues = []
        tableView.reloadData()
        showMessageInTableBackground(message)
    }
    
    func showErrorMessage(_ message: String) {
        leagues = []
        tableView.reloadData()
        showMessageInTableBackground(message)
    }
    
    func navigateToLeagueDetails(leagueId: Int, leagueName: String, sport: Sport) {
        let selectedLeague = leagues.first { $0.id == leagueId }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController else {
            let detailsVC = LeagueDetailsViewController(nibName: "LeagueDetailsViewController", bundle: nil)
            detailsVC.sport = self.sport
            detailsVC.leagueId = leagueId
            detailsVC.league = selectedLeague
            navigationController?.pushViewController(detailsVC, animated: true)
            return
        }

        detailsVC.sport = self.sport
        detailsVC.leagueId = leagueId
        detailsVC.league = selectedLeague
        navigationController?.pushViewController(detailsVC, animated: true)
    }

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
        presenter.didSelectLeague(at: indexPath.row)
    }
}
