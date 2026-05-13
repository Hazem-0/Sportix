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

    private let playerPlaceholderImage = UIImage(named: "placeholderPlayer")
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
        playerImageView.image = playerPlaceholderImage

        numberLabel.text = nil
        numberLabel.isHidden = false
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
        playerImageView.image = playerPlaceholderImage

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

        configurePlayerNumber(player.number)
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
    
    private func configurePlayerNumber(_ number: String) {
        let cleanNumber = number.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if cleanNumber.isEmpty {
            numberLabel.text = nil
            numberLabel.isHidden = true
        } else {
            numberLabel.text = cleanNumber
            numberLabel.isHidden = false
        }
    }

    private func setPlayerImage(from imagePath: String) {
        let placeholder = playerPlaceholderImage

        let cleanImagePath = imagePath.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanImagePath.isEmpty else {
            playerImageView.image = placeholder
            return
        }

        if cleanImagePath.lowercased().hasPrefix("http"),
           let url = URL(string: cleanImagePath) {

            playerImageView.sd_setImage(
                with: url,
                placeholderImage: placeholder,
                options: [.continueInBackground, .retryFailed]
            ) { [weak self] image, _, _, _ in
                guard let self = self else { return }

                if image == nil {
                    self.playerImageView.image = placeholder
                }
            }

        } else {
            playerImageView.image = UIImage(named: cleanImagePath) ?? placeholder
        }
    }
}
