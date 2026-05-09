//
//  SquadTitleTableViewCell.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

final class SquadTitleTableViewCell: UITableViewCell {

    static let identifier = "SquadTitleTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        backgroundColor = AppTheme.Colors.background
        contentView.backgroundColor = AppTheme.Colors.background

        titleLabel.text = "Squad"
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = AppTheme.Colors.textPrimary
    }
}
