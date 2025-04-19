//
//  ShowsListView.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import UIKit
import Common

final class ShowsListView: UIView {

    lazy var emptyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No shows avaiable"
        label.isHidden = true

        return label
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = .init()
        searchBar.placeholder = "Search for shows."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    lazy var showsCollectionView: UICollectionView = {
        let layout: UICollectionViewCompositionalLayout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ShowsListCollectionViewCell.self,
                                forCellWithReuseIdentifier: ShowsListCollectionViewCell.identifier)
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let item: NSCollectionLayoutItem = createItem()
        let section: NSCollectionLayoutSection = createSection(for: item)
        let footer: NSCollectionLayoutBoundarySupplementaryItem = createFooter()
        section.boundarySupplementaryItems = [footer]
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/3.0),
            heightDimension: .fractionalWidth(0.5)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return item
    }

    private func createSection(for item: NSCollectionLayoutItem) -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func createFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                           elementKind: UICollectionView.elementKindSectionFooter,
                                                           alignment: .bottom
        )
    }
}

extension ShowsListView: ViewCoding {

    func setupHierarchy() {
        [showsCollectionView, loadingIndicatorView, emptyLabel].forEach(addSubview)
    }

    func setupConstraints() {
        showsCollectionViewConstraints()
        loadingIndicatorViewConstraints()
        emptyLabelConstraints()
    }

    private func showsCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            showsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            showsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            showsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            showsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func loadingIndicatorViewConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func emptyLabelConstraints() {
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
