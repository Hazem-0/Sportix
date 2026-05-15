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
    
    private let glassyView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
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
        homeLogoImage.layer.cornerRadius = 32
        homeLogoImage.clipsToBounds = true
        homeLogoImage.backgroundColor = .white
        
        awayLogoImage.contentMode = .scaleAspectFit
        awayLogoImage.layer.cornerRadius = 32
        awayLogoImage.clipsToBounds = true
        awayLogoImage.backgroundColor = .white
        
        dateLabel.backgroundColor = .clear
        dateLabel.textColor = AppTheme.Colors.primary
        dateLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        homeTeamName.font = .systemFont(ofSize: 14, weight: .semibold)
        homeTeamName.textColor = AppTheme.Colors.textPrimary
        
        awayTeamName.font = .systemFont(ofSize: 14, weight: .semibold)
        awayTeamName.textColor = AppTheme.Colors.textPrimary
    }
    
    func configure(with fixture: Fixture) {
        dateLabel.text = "\(fixture.date), \(fixture.time)"
        homeTeamName.text = fixture.homeTeamName
        awayTeamName.text = fixture.awayTeamName
        homeLogoImage.sd_setImage(with: URL(string: fixture.homeTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
        awayLogoImage.sd_setImage(with: URL(string: fixture.awayTeamLogo), placeholderImage: UIImage(systemName: "sportscourt"))
    }
}
