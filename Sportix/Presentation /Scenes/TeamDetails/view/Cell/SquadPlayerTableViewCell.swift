//
//  SquadPlayerTableViewCell.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit
import SDWebImage

final class SquadPlayerTableViewCell: UITableViewCell {

    static let identifier = "SquadPlayerTableViewCell"

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        playerImageView.layer.cornerRadius = playerImageView.frame.width / 2
        numberLabel.layer.cornerRadius = numberLabel.frame.height / 2
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        playerImageView.sd_cancelCurrentImageLoad()
        playerImageView.image = UIImage(systemName: "person.crop.circle")

        numberLabel.text = nil
        nameLabel.text = nil
        positionLabel.text = nil
        statusLabel.text = nil
    }

    private func setupUI() {
        selectionStyle = .none

        backgroundColor = AppTheme.Colors.background
        contentView.backgroundColor = AppTheme.Colors.background

        playerImageView.contentMode = .scaleAspectFill
        playerImageView.clipsToBounds = true
        playerImageView.backgroundColor = AppTheme.Colors.card
        playerImageView.tintColor = AppTheme.Colors.primary
        playerImageView.image = UIImage(systemName: "person.crop.circle")

        numberLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        numberLabel.textColor = AppTheme.Colors.primary
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = AppTheme.Colors.primary.withAlphaComponent(0.10)
        numberLabel.clipsToBounds = true

        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = AppTheme.Colors.textPrimary
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.75

        positionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        positionLabel.textColor = AppTheme.Colors.textSecondary
        positionLabel.numberOfLines = 1

        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.clipsToBounds = true

        separatorView.backgroundColor = AppTheme.Colors.border.withAlphaComponent(0.35)
    }

    func configure(with player: Player) {
        setPlayerImage(from: player.imageName)

        numberLabel.text = player.number
        nameLabel.text = player.name
        positionLabel.text = player.position

        if player.isInjured {
            statusLabel.text = "Injured"
            statusLabel.textColor = .systemRed
            statusLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.12)
        } else {
            statusLabel.text = "Healthy"
            statusLabel.textColor = .systemGreen
            statusLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
        }
    }

    private func setPlayerImage(from imagePath: String) {
        let placeholder = UIImage(systemName: "person.crop.circle")

        guard !imagePath.isEmpty else {
            playerImageView.image = placeholder
            return
        }

        if imagePath.lowercased().hasPrefix("http") {
            playerImageView.sd_setImage(
                with: URL(string: imagePath),
                placeholderImage: placeholder
            )
        } else {
            playerImageView.image = UIImage(named: imagePath) ?? placeholder
        }
    }
}
