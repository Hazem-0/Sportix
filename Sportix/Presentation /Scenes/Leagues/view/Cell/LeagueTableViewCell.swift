//
//  LeagueTableViewCell.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

final class LeagueTableViewCell: UITableViewCell {

    static let identifier = "LeagueTableViewCell"

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        badgeImageView.image = nil
        leagueNameLabel.text = nil
        countryLabel.text = nil
    }

    private func setupUI() {
        selectionStyle = .none

        backgroundColor = AppTheme.Colors.background
        contentView.backgroundColor = AppTheme.Colors.background

        badgeImageView.layer.cornerRadius = 22
        badgeImageView.layer.borderWidth = 1
        badgeImageView.layer.borderColor = AppTheme.Colors.border.cgColor
        badgeImageView.clipsToBounds = true
        badgeImageView.contentMode = .scaleAspectFill
        badgeImageView.tintColor = AppTheme.Colors.primary

        leagueNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        leagueNameLabel.textColor = AppTheme.Colors.textPrimary
        leagueNameLabel.numberOfLines = 1

        countryLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        countryLabel.textColor = AppTheme.Colors.primary
        countryLabel.backgroundColor = AppTheme.Colors.primary.withAlphaComponent(0.10)
        countryLabel.textAlignment = .center
        countryLabel.layer.cornerRadius = 8
        countryLabel.clipsToBounds = true
        countryLabel.numberOfLines = 1

        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = AppTheme.Colors.border
        chevronImageView.contentMode = .scaleAspectFit

    }

    func configure(with league: League) {
        leagueNameLabel.text = league.name
        countryLabel.text = "  \(league.country.uppercased())  "

        if league.badge.isEmpty {
            badgeImageView.image = UIImage(systemName: "sportscourt")
        } else {
            badgeImageView.image = UIImage(named: league.badge) ?? UIImage(systemName: "sportscourt")
        }
    }
}
