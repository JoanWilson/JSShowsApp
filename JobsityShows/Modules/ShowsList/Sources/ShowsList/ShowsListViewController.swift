//
//  ShowsListViewController.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import UIKit
import Domain
import Data
import Combine
import ShowDetail

public final class ShowsListViewController: UIViewController, UISearchControllerDelegate {

    private let contentView: ShowsListView = ShowsListView()
    private let viewModel: ShowsListViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var searchController: UISearchController = {
        let controller: UISearchController = .init(searchResultsController: nil)
        controller.delegate = self
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Shows"
        controller.searchBar.delegate = self
        return controller
    }()

    public init(viewModel: ShowsListViewModel = ShowsListViewModel(useCase: ShowsRepository())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    public override func loadView() {
        super.loadView()
        view = contentView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupShowsCollectionView()
        showsBinding()
        setupSearchController()
        loadInitialShows()
    }

    private func loadInitialShows() {
        Task {
            await viewModel.fetchShows(page: viewModel.currentPage)
        }
    }

    private func setupNavbar() {
        title = "Shows"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupShowsCollectionView() {
        contentView.showsCollectionView.dataSource = self
        contentView.showsCollectionView.delegate = self
    }

    private func setupSearchController() {
        definesPresentationContext = true
    }

    private func showsBinding() {
        viewModel.$shows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self: ShowsListViewController else { return }
                self.contentView.showsCollectionView.reloadData()
                self.viewModel.isFetching = false
            }
            .store(in: &cancellables)

        viewModel.$searchResultShows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self: ShowsListViewController else { return }
                self.contentView.showsCollectionView.reloadData()
                self.viewModel.isFetching = false
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self: ShowsListViewController else { return }
                if message != nil {
                    self.viewModel.isFetching = false
                }
            }
            .store(in: &cancellables)
    }

    private func clearSearchings() {
        viewModel.searchText = ""
        Task {
            await MainActor.run {
                self.contentView.showsCollectionView.reloadData()
            }
        }
    }
}

extension ShowsListViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ShowsListCollectionViewCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: ShowsListCollectionViewCell.identifier,
                                 for: indexPath) as? ShowsListCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: viewModel.getShow(for: indexPath.item))
        return cell
    }
}

extension ShowsListViewController: UICollectionViewDelegate {
    private func shouldFetchNextPage(indexPath: IndexPath) -> Bool {
        return viewModel.searchText.isEmpty &&
        indexPath.item >= viewModel.shows.count - 5 &&
        !viewModel.isFetching
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if shouldFetchNextPage(indexPath: indexPath) {
            Task {
                await viewModel.fetchShows(page: viewModel.currentPage)
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetail(show: viewModel.getShow(for: indexPath.item))
    }

    private func navigateToDetail(show: Show) {
        let viewModel: ShowDetailViewModel = ShowDetailViewModel(show: show)
        let hostingController: UIViewController = ShowDetailHostingController(viewModel: viewModel)
        UIView.transition(
            with: navigationController!.view,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.navigationController?.pushViewController(hostingController,
                                                              animated: false)
            },
            completion: nil
        )
    }
}

extension ShowsListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            clearSearchings()
            return
        }
        viewModel.searchText = text
        Task {
            await viewModel.searchShows(query: text)
        }
    }
}

extension ShowsListViewController: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchings()
    }
}
