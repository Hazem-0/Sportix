//
//  LeagueDetailsViewController.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 11/05/2026.
//

import UIKit

protocol LeagueDetailsViewProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func hideLoading()
    func updateFavoriteButton(isFavorite: Bool)
    func showToast(message: String, icon: String)
}

class LeagueDetailsViewController: UIViewController, UICollectionViewDataSource, LeagueDetailsViewProtocol {

    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    private var activityIndicator: UIActivityIndicatorView!

    var presenter: LeagueDetailsPresenterProtocol!
    var sport: Sport = .Football
    var leagueId: Int = 0
    var league: League!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingIndicator()
        setupCollectionView()

        if presenter == nil {
            presenter = LeagueDetailsPresenter(view: self, league: league)
        }

        updateFavoriteButton(isFavorite: presenter.isFavorite)
        presenter.viewDidLoad()
    }

    @IBAction func favButtonTapped(_ sender: UIBarButtonItem) {
        presenter.toggleFavorite()
    }

    private func setupLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    private func setupCollectionView() {
        collectionView.register(UpcomingEventCell.nib, forCellWithReuseIdentifier: UpcomingEventCell.identifier)
        collectionView.register(LatestEventCell.nib, forCellWithReuseIdentifier: LatestEventCell.identifier)
        collectionView.register(TeamCell.nib, forCellWithReuseIdentifier: TeamCell.identifier)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0: return self.createUpcomingSection()
            case 1: return self.createLatestSection()
            case 2: return self.createTeamsSection()
            default: return nil
            }
        }
    }

    private func createUpcomingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createLatestSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(130))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return presenter.upcomingEvents.count
        case 1: return presenter.latestEvents.count
        case 2: return presenter.teams.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingEventCell.identifier, for: indexPath) as! UpcomingEventCell
            cell.configure(with: presenter.upcomingEvents[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestEventCell.identifier, for: indexPath) as! LatestEventCell
            cell.configure(with: presenter.latestEvents[indexPath.row])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.identifier, for: indexPath) as! TeamCell
            cell.configure(with: presenter.teams[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        ) as! SectionHeaderView

        switch indexPath.section {
        case 0: header.titleLabel.text = "Upcoming Events"
        case 1: header.titleLabel.text = "Latest Events"
        case 2: header.titleLabel.text = "Teams"
        default: header.titleLabel.text = ""
        }

        return header
    }

    func reloadData() {
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
    }

    func showToast(message: String, icon: String) {
        showToast(message: message, iconName: icon)
    }
}

extension LeagueDetailsViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard indexPath.section == 2 else { return }

        let selectedTeam = presenter.teams[indexPath.row]

        guard let teamDetailsVC = storyboard?.instantiateViewController(
            withIdentifier: "TeamDetailsViewController"
        ) as? TeamDetailsViewController else {
            print("Could not find TeamDetailsViewController")
            return
        }

        teamDetailsVC.sport = sport
        teamDetailsVC.teamId = selectedTeam.id

        navigationController?.pushViewController(teamDetailsVC, animated: true)
    }
}
