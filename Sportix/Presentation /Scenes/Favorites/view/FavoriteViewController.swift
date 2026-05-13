//
//  FavoriteViewController.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import UIKit

protocol FavoritesView: AnyObject {
    func showFavorites(_ leagues: [League])
    func showEmptyState()
    func navigateToDetails(for league: League)
    func showDeleteConfirmation(leagueName: String, index: Int)
    func showNoInternetAlert()
}

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoritesView {
    
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStateText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavoritesPresenter!
    var favoriteLeagues: [League] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavoritesPresenterImp(view: self)
        setupUI()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background
        tableView.backgroundColor = AppTheme.Colors.background
        
        emptyStateText.textColor = AppTheme.Colors.textSecondary
        emptyStateText.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        setupNavigationTitle()
    }
    
    private func setupNavigationTitle() {
        title = "Favorites"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppTheme.Colors.textPrimary,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        navigationController?.navigationBar.tintColor = AppTheme.Colors.primary
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 78
    }
    
    func showFavorites(_ leagues: [League]) {
        self.favoriteLeagues = leagues
        tableView.isHidden = false
        emptyStateText.isHidden = true
        emptyStateImage.isHidden = true
        tableView.reloadData()
    }
    
    func showEmptyState() {
        self.favoriteLeagues = []
        tableView.isHidden = true
        emptyStateText.isHidden = false
        emptyStateImage.isHidden = false
        tableView.reloadData()
    }
    
    func navigateToDetails(for league: League) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController else {
            let detailsVC = LeagueDetailsViewController(nibName: "LeagueDetailsViewController", bundle: nil)
          
            detailsVC.league = league
            navigationController?.pushViewController(detailsVC, animated: true)
            return
        }

        detailsVC.league = league
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func showDeleteConfirmation(leagueName: String, index: Int) {
        showConfirmation(
            title: "Remove League",
            message: "Are you sure you want to remove \(leagueName) from your favorites?",
            confirmTitle: "Remove",
            isDestructive: true
        ) { [weak self] in
            self?.presenter.confirmDeleteLeague(at: index)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueTableViewCell", for: indexPath) as? LeagueTableViewCell else {
            return UITableViewCell()
        }
        
        let league = favoriteLeagues[indexPath.row]
        cell.configure(with: league)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectLeague(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didTapDeleteLeague(at: indexPath.row)
        }
    }
    func showNoInternetAlert() {
            showAlert(title: "No Internet", message: "Please check your connection and try again.", type: .error)
        }
}
