//
//  TeamDetailsViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit


protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()

    func reloadData()
    func showErrorMessage(_ message: String)
}

final class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var sport: Sport!
    var teamId: Int!

    private var presenter: TeamDetailsPresenterProtocol!
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        setupLoadingIndicator()

        guard setupPresenter() else {
            return
        }

        presenter.viewDidLoad()
    }

    private func setupPresenter() -> Bool {
        guard let sport = sport,
              let teamId = teamId else {
            showErrorMessage("Team data is missing.")
            return false
        }

        let presenter = TeamDetailsPresenter(
            sport: sport,
            teamId: teamId
        )

        presenter.view = self
        self.presenter = presenter

        return true
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = AppTheme.Colors.textPrimary

        navigationItem.title = ""

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }

    private func setupLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = AppTheme.Colors.primary
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = AppTheme.Colors.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()

        registerCells()

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    private func registerCells() {
        let headerNib = UINib(
            nibName: TeamHeaderTableViewCell.identifier,
            bundle: nil
        )

        tableView.register(
            headerNib,
            forCellReuseIdentifier: TeamHeaderTableViewCell.identifier
        )

        let titleNib = UINib(
            nibName: SquadTitleTableViewCell.identifier,
            bundle: nil
        )

        tableView.register(
            titleNib,
            forCellReuseIdentifier: SquadTitleTableViewCell.identifier
        )

        let playerNib = UINib(
            nibName: SquadPlayerTableViewCell.identifier,
            bundle: nil
        )

        tableView.register(
            playerNib,
            forCellReuseIdentifier: SquadPlayerTableViewCell.identifier
        )
    }

    private func showMessageInTableBackground(_ message: String) {
        let label = UILabel()
        label.text = message
        label.textColor = AppTheme.Colors.textSecondary
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0

        tableView.backgroundView = label
    }

    private func hideTableBackgroundMessage() {
        tableView.backgroundView = nil
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension TeamDetailsViewController: TeamDetailsViewProtocol {

    func showLoading() {
        hideTableBackgroundMessage()
        activityIndicator.startAnimating()
        tableView.isHidden = true
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
    }

    func reloadData() {
        hideTableBackgroundMessage()
        tableView.reloadData()
    }

    func showErrorMessage(_ message: String) {
        tableView.reloadData()
        showMessageInTableBackground(message)
    }
}


extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter.getNumberOfRows(in: section)
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TeamHeaderTableViewCell.identifier,
                for: indexPath
            ) as? TeamHeaderTableViewCell else {
                return UITableViewCell()
            }

            guard let team = presenter.getTeamDetails() else {
                return UITableViewCell()
            }

            cell.configure(with: team)
            return cell
        }

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SquadTitleTableViewCell.identifier,
                for: indexPath
            ) as? SquadTitleTableViewCell else {
                return UITableViewCell()
            }

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SquadPlayerTableViewCell.identifier,
            for: indexPath
        ) as? SquadPlayerTableViewCell else {
            return UITableViewCell()
        }

        guard let player = presenter.getPlayer(at: indexPath.row) else {
            return UITableViewCell()
        }

        cell.configure(with: player)

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }

        if indexPath.row == 0 {
            return 64
        }

        return 96
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectRow(
            section: indexPath.section,
            row: indexPath.row
        )
    }
}
