//
//  LatestEventCell.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import UIKit
import SDWebImage

class LatestEventCell: UICollectionViewCell {
    
    static let identifier = "LatestEventCell"
    static let nib = UINib(nibName: "LatestEventCell", bundle: nil)
    
    @IBOutlet weak var homeLogoImage: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayLogoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.backgroundColor = AppTheme.Colors.card
        
        homeLogoImage.contentMode = .scaleAspectFit
        homeLogoImage.layer.cornerRadius = 16
        homeLogoImage.clipsToBounds = true
        
        awayLogoImage.contentMode = .scaleAspectFit
        awayLogoImage.layer.cornerRadius = 16
        awayLogoImage.clipsToBounds = true
        
      
        score.font = .boldSystemFont(ofSize: 18)
        score.textAlignment = .center
       
        
        homeTeamName.font = .systemFont(ofSize: 13)
        awayTeamName.font = .systemFont(ofSize: 13)
    }
    
    func configure(with fixture: Fixture) {
        homeTeamName.text = fixture.homeTeamName
        awayTeamName.text = fixture.awayTeamName
        score.text = "\(fixture.homeTeamScore)  -  \(fixture.awayTeamScore)"
        
        homeLogoImage.sd_setImage(with: URL(string: fixture.homeTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
        awayLogoImage.sd_setImage(with: URL(string: fixture.awayTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
        
        
    }
}
