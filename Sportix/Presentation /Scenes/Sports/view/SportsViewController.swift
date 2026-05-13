//
//  SportsViewController.swift
//  Sportix
//
//  Created by Aalaa Adel on 09/05/2026.
//

import UIKit

final class SportsViewController: UIViewController {

    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var presenter: SportsPresenter!
    private var displayedSports: [Sport] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPresenter()
        setupUI()
        setupCollectionView()

        presenter.viewDidLoad()
    }

    private func setupPresenter() {
        presenter = SportsPresenter(view: self)
    }
    
    private func setupUI() {
        view.backgroundColor = AppTheme.Colors.background

        screenTitleLabel.text = "Sports"
        screenTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        screenTitleLabel.textColor = AppTheme.Colors.textPrimary

    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear

        let nib = UINib(
            nibName: SportCollectionViewCell.identifier,
            bundle: nil
        )

        collectionView.register(
            nib,
            forCellWithReuseIdentifier: SportCollectionViewCell.identifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = AppTheme.Spacing.medium
            layout.minimumInteritemSpacing = AppTheme.Spacing.medium
            layout.sectionInset = .zero
            layout.estimatedItemSize = .zero
        }
    }
}

extension SportsViewController: SportsViewProtocol {
    func showNoInternetAlert() {
           showAlert(title: "No Internet", message: "Please check your connection and try again.", type: .error)
       }
    

    func showSports(_ sports: [Sport]) {
        displayedSports = sports
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func showError(_ message: String) {
        displayedSports = []
        collectionView.reloadData()
        collectionView.isHidden = true

    }
    
    func navigateToLeagues(with sport: Sport) {
        guard let leaguesViewController = storyboard?.instantiateViewController(
            withIdentifier: "LeaguesViewController"
        ) as? LeaguesViewController else {
            print("Could not find LeaguesViewController")
            return
        }

        leaguesViewController.sport = sport

        navigationController?.pushViewController(
            leaguesViewController,
            animated: true
        )
    }
}

extension SportsViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return displayedSports.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SportCollectionViewCell.identifier,
            for: indexPath
        ) as? SportCollectionViewCell else {
            return UICollectionViewCell()
        }

        let sport = displayedSports[indexPath.item]
        cell.configure(with: sport)

        return cell
    }
}

extension SportsViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter.didSelectSport(at: indexPath.item)
    }
}

extension SportsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let itemsPerRow: CGFloat = 2
        let spacing = AppTheme.Spacing.medium

        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / itemsPerRow

        return CGSize(width: cellWidth, height: 220)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return AppTheme.Spacing.medium
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return AppTheme.Spacing.medium
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .zero
    }
}
