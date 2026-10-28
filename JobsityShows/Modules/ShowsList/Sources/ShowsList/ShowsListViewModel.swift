//
//  ShowsListViewModel.swift
//  ShowsList
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation
import Domain
import Tracking

@MainActor
public final class ShowsListViewModel: ObservableObject {

    @Published public var searchText: String = ""
    @Published public var isFetching: Bool = false

    @Published private(set) var shows: [Show] = []
    @Published private(set) var searchResultShows: [Show] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var currentPage: Int = 1

    private var hasPages: Bool = true

    private let useCase: ShowsUseCaseProtocol
    private let tracker: Tracker

    public init(useCase: ShowsUseCaseProtocol, tracker: Tracker = TrackerProvider.current) {
        self.useCase = useCase
        self.tracker = tracker
    }

    public func fetchShows(page: Int) async {
        guard !Task.isCancelled, hasPages else { return }
        isFetching = true
        defer { isFetching = false }
        do {
            let result: [Show] = try await useCase.fetchShows(page: page)
            if page == 1 {
                self.shows = result
            } else {
                self.shows.append(contentsOf: result)
            }

            if page == currentPage {
                currentPage += 1
            }

            errorMessage = nil
        } catch {
            hasPages = false

            if page == 1 {
                errorMessage = "Failed to fetch shows: \(error.localizedDescription)"
                tracker.track(.loadFailed(.showsList))
            }
        }
    }

    public func refreshShows() async {
        guard !Task.isCancelled else { return }
        hasPages = true
        errorMessage = nil
        currentPage = 1
        searchText = ""
        await fetchShows(page: currentPage)
    }

    public func searchShows(query: String) async {
        guard !Task.isCancelled else { return }
        isFetching = true
        defer { isFetching = false }
        do {
            let results = try await useCase.searchShows(query: query)
            self.searchResultShows = results
            errorMessage = nil
        } catch {
            errorMessage = "Failed to search shows: \(error.localizedDescription)"
            self.searchResultShows = []
        }
    }

    public func numberOfItems() -> Int {
        if searchText.isEmpty == false {
            return searchResultShows.count
        } else {
            return shows.count
        }
    }

    public func getShow(for indexPath: Int) -> Show {
        if searchText.isEmpty == false {
            return searchResultShows[indexPath]
        } else {
            return shows[indexPath]
        }
    }

    public func selectShow(at index: Int) -> Show {
        let show: Show = getShow(for: index)
        tracker.track(.selectShow(id: show.id, name: show.name, fromSearch: !searchText.isEmpty))
        return show
    }

    public func trackScreenView() {
        tracker.track(.screenView(.showsList))
    }

    public func trackSearch(term: String) {
        tracker.track(.search(term: term))
    }

}
