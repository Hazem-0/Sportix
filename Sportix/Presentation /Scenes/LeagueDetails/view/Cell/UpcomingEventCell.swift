//
//  UpcomingEventCell.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import UIKit
import SDWebImage

class UpcomingEventCell: UICollectionViewCell {
    
    static let identifier = "UpcomingEventCell"
    static let nib = UINib(nibName: "UpcomingEventCell", bundle: nil)
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayLogoImage: UIImageView!
    @IBOutlet weak var homeLogoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.backgroundColor = AppTheme.Colors.card
        homeLogoImage.contentMode = .scaleAspectFit
        homeLogoImage.layer.cornerRadius = 32
        homeLogoImage.clipsToBounds = true
        awayLogoImage.contentMode = .scaleAspectFit
        awayLogoImage.layer.cornerRadius = 32
        awayLogoImage.clipsToBounds = true
        
        dateLabel.backgroundColor = AppTheme.Colors.card
        dateLabel.textColor = AppTheme.Colors.success
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
    }
    
    func configure(with fixture: Fixture) {
        dateLabel.text = "\(fixture.date), \(fixture.time)"
        homeTeamName.text = fixture.homeTeamName
        awayTeamName.text = fixture.awayTeamName
        homeLogoImage.sd_setImage(with: URL(string: fixture.homeTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
        awayLogoImage.sd_setImage(with: URL(string: fixture.awayTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
    }
}
