//
//  LeagueDetailsViewController.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 08/05/2026.
//

import UIKit

protocol LeagueDetailsViewProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func hideLoading()
    func updateFavoriteButton(isFavorite: Bool)
    func setFavoriteButton(enabled: Bool)
    func showToast(message: String, icon: String)
    func showNoInternetAlert()
    func navigateToTeamDetails(sport: Sport, teamId: Int)
}

class EmptyStateCell: UICollectionViewCell {
    static let identifier = "EmptyStateCell"
    let messageLabel = UILabel()
    private let glassyView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.withAlphaComponent(0.05).cgColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(glassyView)
        glassyView.contentView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .secondaryLabel

        NSLayoutConstraint.activate([
            glassyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glassyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            glassyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            glassyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: glassyView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: glassyView.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: glassyView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: glassyView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with message: String) {
        messageLabel.text = message
    }
}

class LeagueDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, LeagueDetailsViewProtocol {

    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppTheme.Colors.primary
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    var presenter: LeagueDetailsPresenterProtocol!
    var sport: Sport = .Football
    var league: League!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = league.name
        applyTheme()
        setupLoadingIndicator()
        setupCollectionView()
        attachView()
        updateFavoriteButton(isFavorite: presenter.isFavorite)
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteButton(isFavorite: presenter.isFavorite)
    }

    @IBAction private func favButtonTapped(_ sender: UIBarButtonItem) {
        presenter.toggleFavorite()
    }

    private func applyTheme() {
        view.backgroundColor = AppTheme.Colors.background
        collectionView.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = AppTheme.Colors.primary
    }

    private func setupLoadingIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.register(UpcomingEventCell.nib, forCellWithReuseIdentifier: UpcomingEventCell.identifier)
        collectionView.register(LatestEventCell.nib,   forCellWithReuseIdentifier: LatestEventCell.identifier)
        collectionView.register(TeamCell.nib,          forCellWithReuseIdentifier: TeamCell.identifier)
        collectionView.register(EmptyStateCell.self,   forCellWithReuseIdentifier: EmptyStateCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = makeCompositionalLayout()
    }

    private func attachView() {
        guard presenter == nil else { return }
        presenter = LeagueDetailsPresenter(view: self, league: league)
    }

    private func makeCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.presenter.visibleSections[sectionIndex]
            
            if self.presenter.isEmpty(section: section) {
                return self.makeEmptySection()
            }
            
            switch section {
            case .teams:    return self.makeTeamsSection()
            case .upcoming: return self.makeUpcomingSection()
            case .latest:   return self.makeLatestSection()
            }
        }
    }

    private func makeEmptySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140)), subitems: [item])
        return buildSection(group: group, orthogonal: .none)
    }

    private func makeUpcomingSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(190)), subitems: [item])
        return buildSection(group: group, orthogonal: .groupPagingCentered)
    }

    private func makeLatestSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(96)), subitems: [item])
        return buildSection(group: group, orthogonal: .none)
    }

    private func makeTeamsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(140)), subitems: [item])
        return buildSection(group: group, orthogonal: .continuous)
    }

    private func buildSection(group: NSCollectionLayoutGroup, orthogonal scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollBehavior
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 32, trailing: 16)
        section.boundarySupplementaryItems = [makeHeaderItem()]
        return section
    }

    private func makeHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.visibleSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let leagueSection = presenter.visibleSections[section]
        return presenter.numberOfItems(in: leagueSection)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = presenter.visibleSections[indexPath.section]

        if presenter.isEmpty(section: section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCell.identifier, for: indexPath) as? EmptyStateCell else { return UICollectionViewCell() }
            let message: String
            switch section {
            case .teams: message = "No teams available for this league."
            case .upcoming: message = "No upcoming events scheduled."
            case .latest: message = "No past event results available."
            }
            cell.configure(with: message)
            return cell
        }

        switch section {
        case .teams:
            let teams = presenter.teams(for: section)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.identifier, for: indexPath) as? TeamCell else { return UICollectionViewCell() }
            cell.configure(with: teams[indexPath.row])
            return cell

        case .upcoming:
            let events = presenter.upcomingEvents(for: section)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingEventCell.identifier, for: indexPath) as? UpcomingEventCell else { return UICollectionViewCell() }
            cell.configure(with: events[indexPath.row])
            return cell

        case .latest:
            let events = presenter.latestEvents(for: section)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestEventCell.identifier, for: indexPath) as? LatestEventCell else { return UICollectionViewCell() }
            cell.configure(with: events[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }

        header.titleLabel.text = presenter.visibleSections[indexPath.section].title
        header.titleLabel.textColor = AppTheme.Colors.textPrimary
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = presenter.visibleSections[indexPath.section]
        if section == .teams && !presenter.isEmpty(section: section) {
            presenter.didSelectTeam(at: indexPath.row)
        }
    }

    func reloadData() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }

    func showLoading() {
        activityIndicator.startAnimating()
        collectionView.isHidden = true
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
    }

    func updateFavoriteButton(isFavorite: Bool) {
        favButton.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
        favButton.tintColor = isFavorite ? AppTheme.Colors.favorite : AppTheme.Colors.primary
    }

    func setFavoriteButton(enabled: Bool) {
        favButton.isEnabled = enabled
    }

    func showToast(message: String, icon: String) {
        showToast(message: message, iconName: icon)
    }

    func showNoInternetAlert() {
        showAlert(title: "No Internet", message: "Please check your connection and try again.", type: .error)
    }
    
    func navigateToTeamDetails(sport: Sport, teamId: Int) {
        guard let teamDetailsVC = storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController else { return }
        teamDetailsVC.sport = sport
        teamDetailsVC.teamId = teamId
        navigationController?.pushViewController(teamDetailsVC, animated: true)
    }
}
