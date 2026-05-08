//
//  FavoriteViewController.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStateText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // 1. Change this to an array of League objects
    var favoriteLeagues: [League] = [
        League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png"),
        League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png"),
        League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png"),
        League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png"),
        League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png"),
        League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png")
        , League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png")
        , League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png")
        , League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png")
        , League(id: 1, name: "Premier League", sport: .Football, country: "England", badge: "https://dorve.com/wp-content/uploads/2023/08/premierleague-1024x1024.png")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateView()
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "FavoriteCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavoriteCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func updateView() {
        let hasFavorites = !favoriteLeagues.isEmpty
        tableView.isHidden = !hasFavorites
        emptyStateText.isHidden = hasFavorites
        emptyStateImage.isHidden = hasFavorites
    }
    
    @IBAction func browseSportsTapped(_ sender: UIButton) { }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        // 2. Pass the League object to the config function!
        let league = favoriteLeagues[indexPath.row]
        cell.congifg(league: league)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
