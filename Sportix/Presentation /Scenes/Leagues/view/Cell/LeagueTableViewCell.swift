//
//  LeagueTableViewCell.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

final class LeagueTableViewCell: UITableViewCell {

    static let identifier = "LeagueTableViewCell"

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!


    private var imageTask: URLSessionDataTask?
    private var currentBadgePath: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageTask?.cancel()
        imageTask = nil
        currentBadgePath = nil
        
        badgeImageView.image = UIImage(systemName: "sportscourt")
        leagueNameLabel.text = nil
        countryLabel.text = nil
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        backgroundColor = AppTheme.Colors.background
        contentView.backgroundColor = AppTheme.Colors.background
        
        badgeImageView.layer.cornerRadius = 27
        badgeImageView.layer.borderWidth = 1
        badgeImageView.layer.borderColor = AppTheme.Colors.border.cgColor
        badgeImageView.clipsToBounds = true
        badgeImageView.contentMode = .scaleAspectFill
        badgeImageView.tintColor = AppTheme.Colors.primary
        badgeImageView.image = UIImage(systemName: "sportscourt")
        
        leagueNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        leagueNameLabel.textColor = AppTheme.Colors.textPrimary
        leagueNameLabel.numberOfLines = 1
        
        countryLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        countryLabel.textColor = AppTheme.Colors.primary
        countryLabel.backgroundColor = AppTheme.Colors.primary.withAlphaComponent(0.10)
        countryLabel.textAlignment = .center
        countryLabel.layer.cornerRadius = 8
        countryLabel.clipsToBounds = true
        countryLabel.numberOfLines = 1
        
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = AppTheme.Colors.border
        chevronImageView.contentMode = .scaleAspectFit
    }
    
    func configure(with league: League) {
        leagueNameLabel.text = league.name
        countryLabel.text = "  \(league.country.uppercased())  "
        setBadgeImage(from: league.badge)
    }
    
    private func setBadgeImage(from badge: String) {
        imageTask?.cancel()
        currentBadgePath = badge
        
        let placeholder = UIImage(systemName: "sportscourt")
        
        guard !badge.isEmpty else {
            badgeImageView.image = placeholder
            return
        }
        
        if badge.lowercased().hasPrefix("http"),
           let url = URL(string: badge) {
            
            badgeImageView.image = placeholder
            
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self else { return }
                
                guard self.currentBadgePath == badge else {
                    return
                }
                
                guard let data = data,
                      let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        
                        self.badgeImageView.image = placeholder
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.badgeImageView.image = image
                }
            }
            
            imageTask?.resume()
            
        } else {
            badgeImageView.image = UIImage(named: badge) ?? placeholder
        }
    }
}
