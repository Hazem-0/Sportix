//
//  SportCollectionViewCell.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

class SportCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "SportCollectionViewCell"

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sportNameLabel: UILabel!
    @IBOutlet weak var sportImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        sportImageView.image = nil
        sportNameLabel.text = nil
    }

    private func setupUI() {
        contentView.backgroundColor = .clear

        cardView.backgroundColor = AppTheme.Colors.card
        cardView.layer.cornerRadius = AppTheme.Radius.medium
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = AppTheme.Colors.border.cgColor
        cardView.clipsToBounds = true

        sportImageView.contentMode = .scaleAspectFill
        sportImageView.clipsToBounds = true

        sportNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        sportNameLabel.textColor = AppTheme.Colors.textPrimary
        sportNameLabel.numberOfLines = 1
    }

    func configure(with sport: Sport) {
        sportImageView.image = UIImage(named: sport.imageName)
        sportNameLabel.text = sport.displayName
    }
}
