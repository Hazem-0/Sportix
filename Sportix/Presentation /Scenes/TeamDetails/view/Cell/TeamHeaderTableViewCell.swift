//
//  TeamHeaderTableViewCell.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

final class TeamHeaderTableViewCell: UITableViewCell {

    static let identifier = "TeamHeaderTableViewCell"

    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        teamLogoImageView.layer.cornerRadius = teamLogoImageView.frame.width / 2
        countryLabel.layer.cornerRadius = countryLabel.frame.height / 2
    }

    private func setupUI() {
        selectionStyle = .none

        backgroundColor = AppTheme.Colors.background
        contentView.backgroundColor = AppTheme.Colors.background

        teamLogoImageView.backgroundColor = .white
        teamLogoImageView.contentMode = .scaleAspectFit
        teamLogoImageView.clipsToBounds = true
        teamLogoImageView.layer.borderWidth = 2
        teamLogoImageView.layer.borderColor = AppTheme.Colors.primary.cgColor

        teamNameLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        teamNameLabel.textColor = AppTheme.Colors.textPrimary
        teamNameLabel.textAlignment = .center
        teamNameLabel.numberOfLines = 1
        teamNameLabel.adjustsFontSizeToFitWidth = true
        teamNameLabel.minimumScaleFactor = 0.75

        countryLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        countryLabel.textColor = AppTheme.Colors.primary
        countryLabel.backgroundColor = AppTheme.Colors.primary.withAlphaComponent(0.10)
        countryLabel.textAlignment = .center
        countryLabel.clipsToBounds = true
    }

    func configure(with team: TeamDetails) {
        teamLogoImageView.image = UIImage(named: team.logoName)
        teamNameLabel.text = team.name
        countryLabel.text = "  \(team.countryFlag) \(team.country)  "
    }
}
