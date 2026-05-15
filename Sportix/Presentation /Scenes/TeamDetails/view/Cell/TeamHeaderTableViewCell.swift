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

   
    private let glassyBackgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.insertSubview(glassyBackgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            glassyBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            glassyBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            glassyBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            glassyBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

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
