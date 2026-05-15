//
//  TeamCell.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import UIKit
import SDWebImage

import UIKit
import SDWebImage

class TeamCell: UICollectionViewCell {
    
    static let identifier = "TeamCell"
    static let nib = UINib(nibName: "TeamCell", bundle: nil)
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    private let glassyView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
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
        
        logoImage.contentMode = .scaleAspectFit
        logoImage.layer.cornerRadius = 32
        logoImage.clipsToBounds = true
        logoImage.backgroundColor = .white
        
        teamName.textAlignment = .center
        teamName.font = .systemFont(ofSize: 13, weight: .semibold)
        teamName.textColor = AppTheme.Colors.textPrimary
        teamName.numberOfLines = 2
    }
    
    func configure(with team: TeamDetails) {
        teamName.text = team.name
        logoImage.sd_setImage(with: URL(string: team.logoName), placeholderImage: UIImage(systemName: "sportscourt.circle"))
    }
}
