//
//  TeamHeaderTableViewCell.swift
//  Sportix
//

import UIKit
import SDWebImage

final class TeamHeaderTableViewCell: UITableViewCell {

    static let identifier = "TeamHeaderTableViewCell"

    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        teamLogoImageView.layer.cornerRadius = teamLogoImageView.frame.width / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        teamLogoImageView.image = UIImage(systemName: "sportscourt.circle")
        teamNameLabel.text = nil
    }

    private func setupUI() {
        selectionStyle = .none

        backgroundColor = AppTheme.Colors.background
        contentView.backgroundColor = AppTheme.Colors.background

        teamLogoImageView.backgroundColor = .white
        teamLogoImageView.contentMode = .scaleAspectFit
        teamLogoImageView.clipsToBounds = true
        teamLogoImageView.tintColor = AppTheme.Colors.primary
        teamLogoImageView.layer.borderWidth = 2
        teamLogoImageView.layer.borderColor = AppTheme.Colors.primary.cgColor

        teamNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        teamNameLabel.textColor = AppTheme.Colors.textPrimary
        teamNameLabel.textAlignment = .center
        teamNameLabel.numberOfLines = 1
        teamNameLabel.adjustsFontSizeToFitWidth = true
        teamNameLabel.minimumScaleFactor = 0.75
    }

    func configure(with team: TeamDetails) {
        teamNameLabel.text = team.name

        let placeholder = UIImage(systemName: "sportscourt.circle")

        if team.logoName.lowercased().hasPrefix("http") {
            teamLogoImageView.sd_setImage(
                with: URL(string: team.logoName),
                placeholderImage: placeholder
            )
        } else {
            teamLogoImageView.image = UIImage(named: team.logoName) ?? placeholder
        }
    }
}
