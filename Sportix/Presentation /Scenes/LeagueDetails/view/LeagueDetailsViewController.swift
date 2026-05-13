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
    func showToast(message: String, icon: String)
    func showNoInternetAlert()
    func navigateToTeamDetails(sport: Sport, teamId: Int)
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
        bootstrapPresenter()
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
        collectionView.backgroundColor = AppTheme.Colors.background
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
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = makeCompositionalLayout()
    }

    private func bootstrapPresenter() {
        guard presenter == nil else { return }
        presenter = LeagueDetailsPresenter(view: self, league: league)
    }

    private func makeCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.presenter.visibleSections[sectionIndex]
            switch section {
            case .upcoming: return self.makeUpcomingSection()
            case .latest:   return self.makeLatestSection()
            case .teams:    return self.makeTeamsSection()
            }
        }
    }

    private func makeUpcomingSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(220)),
            subitems: [item]
        )
        return buildSection(group: group, orthogonal: .continuous)
    }

    private func makeLatestSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)),
            subitems: [item]
        )
        return buildSection(group: group, orthogonal: .none)
    }

    private func makeTeamsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .absolute(110), heightDimension: .absolute(130)),
            subitems: [item]
        )
        return buildSection(group: group, orthogonal: .continuous)
    }

    private func buildSection(
        group: NSCollectionLayoutGroup,
        orthogonal scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollBehavior
        section.interGroupSpacing           = AppTheme.Spacing.medium
        section.contentInsets = NSDirectionalEdgeInsets(
            top:      AppTheme.Spacing.small,
            leading:  AppTheme.Spacing.medium,
            bottom:   AppTheme.Spacing.large,
            trailing: AppTheme.Spacing.medium
        )
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

    private func dequeueCell<T: UICollectionViewCell>(
        from collectionView: UICollectionView,
        withReuseIdentifier id: String,
        for indexPath: IndexPath
    ) -> T? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? T
    }

    private func dequeueSupplementary<T: UICollectionReusableView>(
        from collectionView: UICollectionView,
        ofKind kind: String,
        withReuseIdentifier id: String,
        for indexPath: IndexPath
    ) -> T? {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? T
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.visibleSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let leagueSection = presenter.visibleSections[section]
        return presenter.numberOfItems(in: leagueSection)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = presenter.visibleSections[indexPath.section]

        switch section {
        case .upcoming:
            let events = presenter.upcomingEvents(for: section)
            guard
                let cell: UpcomingEventCell = dequeueCell(from: collectionView, withReuseIdentifier: UpcomingEventCell.identifier, for: indexPath),
                indexPath.row < events.count
            else { return UICollectionViewCell() }
            
            cell.configure(with: events[indexPath.row])
            return cell

        case .latest:
            let events = presenter.latestEvents(for: section)
            guard
                let cell: LatestEventCell = dequeueCell(from: collectionView, withReuseIdentifier: LatestEventCell.identifier, for: indexPath),
                indexPath.row < events.count
            else { return UICollectionViewCell() }
            
            cell.configure(with: events[indexPath.row])
            return cell

        case .teams:
            let teams = presenter.teams(for: section)
            guard
                let cell: TeamCell = dequeueCell(from: collectionView, withReuseIdentifier: TeamCell.identifier, for: indexPath),
                indexPath.row < teams.count
            else { return UICollectionViewCell() }
            
            cell.configure(with: teams[indexPath.row])
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header: SectionHeaderView = dequeueSupplementary(from: collectionView, ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath)
        else { return UICollectionReusableView() }

        header.titleLabel.text      = presenter.visibleSections[indexPath.section].title
        header.titleLabel.textColor = AppTheme.Colors.textPrimary
        return header
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let section = presenter.visibleSections[indexPath.section]
        if section == .teams {
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
        favButton.image     = UIImage(systemName: isFavorite ? "star.fill" : "star")
        favButton.tintColor = isFavorite ? AppTheme.Colors.favorite : AppTheme.Colors.primary
    }

    func showToast(message: String, icon: String) {
        
    }

    func showNoInternetAlert() {
        showAlert(title: "No Internet", message: "Please check your connection and try again.", type: .error)
    }
    
    func navigateToTeamDetails(sport: Sport, teamId: Int) {
        guard let teamDetailsVC = storyboard?.instantiateViewController(
            withIdentifier: "TeamDetailsViewController"
        ) as? TeamDetailsViewController else {
            assertionFailure("TeamDetailsViewController not found in storyboard.")
            return
        }

        teamDetailsVC.sport  = sport
        teamDetailsVC.teamId = teamId
        navigationController?.pushViewController(teamDetailsVC, animated: true)
    }
}
