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
    @IBOutlet weak var homeScoreLabel: UILabel!
    
    @IBOutlet weak var awayLogoImage: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    private let glassyView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.withAlphaComponent(0.05).cgColor
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.insertSubview(glassyView, at: 0)
        NSLayoutConstraint.activate([
            glassyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glassyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            glassyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            glassyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        homeLogoImage.contentMode = .scaleAspectFit
        homeLogoImage.layer.cornerRadius = 14
        homeLogoImage.clipsToBounds = true
        homeLogoImage.backgroundColor = .white
        
        awayLogoImage.contentMode = .scaleAspectFit
        awayLogoImage.layer.cornerRadius = 14
        awayLogoImage.clipsToBounds = true
        awayLogoImage.backgroundColor = .white
        
        homeScoreLabel.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        awayScoreLabel.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        
        homeTeamName.font = .systemFont(ofSize: 16, weight: .semibold)
        homeTeamName.textColor = AppTheme.Colors.textPrimary
        
        awayTeamName.font = .systemFont(ofSize: 16, weight: .semibold)
        awayTeamName.textColor = AppTheme.Colors.textPrimary
    }
    
    func configure(with fixture: Fixture) {
        homeTeamName.text = fixture.homeTeamName
        awayTeamName.text = fixture.awayTeamName
        
        homeScoreLabel.text = "\(fixture.homeTeamScore)"
        awayScoreLabel.text = "\(fixture.awayTeamScore)"
        
        homeLogoImage.sd_setImage(with: URL(string: fixture.homeTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
        awayLogoImage.sd_setImage(with: URL(string: fixture.awayTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
    }
}
