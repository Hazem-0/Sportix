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
}

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoritesView{
    
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStateText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavoritesPresenter!
    var favoriteLeagues: [League] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavoritesPresenterImp(view: self)
        setupTableView()
        presenter.viewDidLoad()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "FavoriteCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavoriteCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        let league = favoriteLeagues[indexPath.row]
        cell.congifg(league: league)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteLeague(at: indexPath.row)
        }
    }
    
    
    
    
}
