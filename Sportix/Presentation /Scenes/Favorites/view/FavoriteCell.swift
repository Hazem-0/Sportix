//
//  FavoriteCell.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import UIKit
import SDWebImage

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var sportType: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favImage.clipsToBounds = true
        favImage.layer.borderWidth = 1.0
        favImage.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    // Add this function: It calculates the circle AFTER the cell is sized
    override func layoutSubviews() {
        super.layoutSubviews()
        favImage.layer.cornerRadius = favImage.frame.size.height / 2
    }

    func congifg(league: League) {
        leagueName.text = league.name
        country.text = league.country
        sportType.text = "\(league.sport)"
        
        let placeholder = UIImage(systemName: "photo.circle.fill")
        favImage.tintColor = .systemGray3
        
        if let url = URL(string: league.badge) {
            favImage.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            favImage.image = placeholder
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
