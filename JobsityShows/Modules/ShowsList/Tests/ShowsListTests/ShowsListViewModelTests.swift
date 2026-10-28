//
//  ShowsListViewModelTests.swift
//  ShowsListTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
import Domain
@testable import ShowsList

@MainActor
final class ShowsListViewModelTests: XCTestCase {

    func test_fetchShows_firstPage_setsShowsAndAdvancesCurrentPage() async {
        let (sut, useCase) = makeSUT()
        useCase.fetchShowsHandler = { _ in [.fixture(id: 1), .fixture(id: 2)] }

        await sut.fetchShows(page: 1)

        XCTAssertEqual(useCase.requestedPages, [1])
        XCTAssertEqual(sut.shows.map(\.id), [1, 2])
        XCTAssertEqual(sut.currentPage, 2)
        XCTAssertNil(sut.errorMessage)
    }

    func test_fetchShows_nextPage_appendsShows() async {
        let (sut, useCase) = makeSUT()
        useCase.fetchShowsHandler = { page in [.fixture(id: page)] }

        await sut.fetchShows(page: 1)
        await sut.fetchShows(page: 2)

        XCTAssertEqual(sut.shows.map(\.id), [1, 2])
        XCTAssertEqual(sut.currentPage, 3)
    }

    func test_fetchShows_resetsIsFetchingWhenFinished() async {
        let (sut, useCase) = makeSUT()

        await sut.fetchShows(page: 1)
        XCTAssertFalse(sut.isFetching, "isFetching should be reset after a successful fetch")

        useCase.fetchShowsHandler = { _ in throw StubError.failure }
        await sut.fetchShows(page: 2)
        XCTAssertFalse(sut.isFetching, "isFetching should be reset after a failed fetch")
    }

    func test_fetchShows_firstPageFailure_setsErrorMessage() async {
        let (sut, useCase) = makeSUT()
        useCase.fetchShowsHandler = { _ in throw StubError.failure }

        await sut.fetchShows(page: 1)

        XCTAssertTrue(sut.shows.isEmpty)
        XCTAssertEqual(sut.errorMessage?.hasPrefix("Failed to fetch shows"), true)
    }

    func test_fetchShows_nextPageFailure_keepsShowsWithoutErrorAndStopsPaginating() async {
        let (sut, useCase) = makeSUT()
        useCase.fetchShowsHandler = { page in
            guard page == 1 else { throw StubError.failure }
            return [.fixture(id: 1)]
        }

        await sut.fetchShows(page: 1)
        await sut.fetchShows(page: 2)
        await sut.fetchShows(page: 2)

        XCTAssertEqual(useCase.requestedPages, [1, 2], "No further pages should be requested after a failure")
        XCTAssertEqual(sut.shows.map(\.id), [1])
        XCTAssertNil(sut.errorMessage)
    }

    func test_refreshShows_resetsStateAndReloadsFirstPage() async {
        let (sut, useCase) = makeSUT()
        useCase.fetchShowsHandler = { page in
            guard page == 1 else { throw StubError.failure }
            return [.fixture(id: 1)]
        }
        await sut.fetchShows(page: 1)
        await sut.fetchShows(page: 2)
        sut.searchText = "dome"

        useCase.fetchShowsHandler = { _ in [.fixture(id: 9)] }
        await sut.refreshShows()

        XCTAssertEqual(useCase.requestedPages.last, 1)
        XCTAssertEqual(sut.shows.map(\.id), [9])
        XCTAssertEqual(sut.currentPage, 2)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertNil(sut.errorMessage)
    }

    func test_searchShows_success_setsSearchResults() async {
        let (sut, useCase) = makeSUT()
        useCase.searchShowsHandler = { _ in [.fixture(id: 7)] }

        await sut.searchShows(query: "dome")

        XCTAssertEqual(useCase.searchedQueries, ["dome"])
        XCTAssertEqual(sut.searchResultShows.map(\.id), [7])
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isFetching)
    }

    func test_searchShows_failure_clearsPreviousResultsAndSetsErrorMessage() async {
        let (sut, useCase) = makeSUT()
        useCase.searchShowsHandler = { _ in [.fixture(id: 7)] }
        await sut.searchShows(query: "dome")

        useCase.searchShowsHandler = { _ in throw StubError.failure }
        await sut.searchShows(query: "dome 2")

        XCTAssertTrue(sut.searchResultShows.isEmpty)
        XCTAssertEqual(sut.errorMessage?.hasPrefix("Failed to search shows"), true)
        XCTAssertFalse(sut.isFetching)
    }

    func test_dataSource_withoutSearchText_usesShows() async {
        let (sut, useCase) = makeSUT()
        useCase.fetchShowsHandler = { _ in [.fixture(id: 1), .fixture(id: 2)] }
        useCase.searchShowsHandler = { _ in [.fixture(id: 7)] }
        await sut.fetchShows(page: 1)
        await sut.searchShows(query: "dome")

        sut.searchText = ""

        XCTAssertEqual(sut.numberOfItems(), 2)
        XCTAssertEqual(sut.getShow(for: 1).id, 2)
    }

    func test_dataSource_withSearchText_usesSearchResults() async {
        let (sut, useCase) = makeSUT()
        useCase.fetchShowsHandler = { _ in [.fixture(id: 1), .fixture(id: 2)] }
        useCase.searchShowsHandler = { _ in [.fixture(id: 7)] }
        await sut.fetchShows(page: 1)
        await sut.searchShows(query: "dome")

        sut.searchText = "dome"

        XCTAssertEqual(sut.numberOfItems(), 1)
        XCTAssertEqual(sut.getShow(for: 0).id, 7)
    }

    private func makeSUT() -> (sut: ShowsListViewModel, useCase: ShowsUseCaseStub) {
        let useCase = ShowsUseCaseStub()
        return (ShowsListViewModel(useCase: useCase), useCase)
    }
}
