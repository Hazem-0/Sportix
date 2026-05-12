//
//  TeamCell.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import UIKit
import SDWebImage

class TeamCell: UICollectionViewCell {
    
    static let identifier = "TeamCell"
    static let nib = UINib(nibName: "TeamCell", bundle: nil)
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        logoImage.contentMode = .scaleAspectFit
        logoImage.layer.cornerRadius = 24
        logoImage.clipsToBounds = true
        
        teamName.textAlignment = .center
        teamName.font = .systemFont(ofSize: 11)
        teamName.numberOfLines = 1
    }
    
    func configure(with team: TeamDetails) {
        teamName.text = team.name
        logoImage.sd_setImage(with: URL(string: team.logoName), placeholderImage: UIImage(systemName: "sportscourt.circle"))
    }
}
