//
//  ShowDetailViewModelTests.swift
//  ShowDetailTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
import Domain
import Tracking
@testable import ShowDetail

@MainActor
final class ShowDetailViewModelTests: XCTestCase {

    func test_loadData_fetchesShowSeasonsAndFirstSeasonEpisodes() async {
        let (sut, useCase) = makeSUT(showId: 1)
        useCase.fetchShowByIdResult = .success(.fixture(id: 1))
        useCase.fetchSeasonsResult = .success([.fixture(id: 10, number: 1), .fixture(id: 11, number: 2)])
        useCase.fetchEpisodesHandler = { seasonId in [.fixture(id: seasonId * 10)] }

        await sut.loadData()

        XCTAssertEqual(useCase.requestedShowIds, [1])
        XCTAssertEqual(useCase.requestedSeasonsShowIds, [1])
        XCTAssertEqual(useCase.requestedEpisodesSeasonIds, [10])
        XCTAssertEqual(sut.show?.id, 1)
        XCTAssertEqual(sut.seasons.map(\.id), [10, 11])
        XCTAssertEqual(sut.selectedSeason?.id, 10)
        XCTAssertEqual(sut.episodes.map(\.id), [100])
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }

    func test_loadData_whenShowFailsWithoutInitialShow_keepsShowErrorAndSkipsSeasons() async {
        let (sut, useCase) = makeSUT(showId: 1)
        useCase.fetchShowByIdResult = .failure(StubError.failure)

        await sut.loadData()

        XCTAssertNil(sut.show)
        XCTAssertEqual(sut.error, .showError)
        XCTAssertTrue(useCase.requestedSeasonsShowIds.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadData_whenShowRefreshFailsWithInitialShow_keepsInitialShowAndLoadsSeasons() async {
        let initialShow = Show.fixture(id: 1)
        let useCase = ShowsUseCaseStub()
        let sut = ShowDetailViewModel(show: initialShow, useCase: useCase)
        useCase.fetchShowByIdResult = .failure(StubError.failure)
        useCase.fetchSeasonsResult = .success([.fixture(id: 10)])

        await sut.loadData()

        XCTAssertEqual(sut.show, initialShow)
        XCTAssertEqual(sut.seasons.map(\.id), [10])
        XCTAssertEqual(useCase.requestedEpisodesSeasonIds, [10])
    }

    func test_loadData_withNoSeasons_finishesLoadingWithoutFetchingEpisodes() async {
        let (sut, useCase) = makeSUT(showId: 1)
        useCase.fetchShowByIdResult = .success(.fixture(id: 1))
        useCase.fetchSeasonsResult = .success([])

        await sut.loadData()

        XCTAssertTrue(useCase.requestedEpisodesSeasonIds.isEmpty)
        XCTAssertNil(sut.selectedSeason)
        XCTAssertFalse(sut.isLoading, "isLoading should not stay true when there are no seasons")
    }

    func test_fetchSeasons_success_returnsFirstSeasonAndResetsIsLoading() async {
        let (sut, useCase) = makeSUT(showId: 1)
        useCase.fetchSeasonsResult = .success([.fixture(id: 10), .fixture(id: 11)])

        let firstSeason = await sut.fetchSeasons()

        XCTAssertEqual(firstSeason?.id, 10)
        XCTAssertFalse(sut.isLoading)
    }

    func test_fetchSeasons_failure_setsSeasonError() async {
        let (sut, useCase) = makeSUT(showId: 1)
        useCase.fetchSeasonsResult = .failure(StubError.failure)

        let firstSeason = await sut.fetchSeasons()

        XCTAssertNil(firstSeason)
        XCTAssertEqual(sut.error, .seasonError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_fetchEpisodes_withoutSelectedSeason_doesNothing() async {
        let (sut, useCase) = makeSUT(showId: 1)

        await sut.fetchEpisodes()

        XCTAssertTrue(useCase.requestedEpisodesSeasonIds.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func test_fetchEpisodes_failure_setsEpisodesError() async {
        let (sut, useCase) = makeSUT(showId: 1)
        useCase.fetchEpisodesHandler = { _ in throw StubError.failure }

        await sut.fetchEpisodes(for: .fixture(id: 10))

        XCTAssertEqual(sut.error, .episodesError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_selectSeason_updatesSelectionAndFetchesItsEpisodes() async {
        let (sut, useCase) = makeSUT(showId: 1)
        useCase.fetchEpisodesHandler = { seasonId in [.fixture(id: seasonId * 10, season: 2)] }

        await sut.selectSeason(season: .fixture(id: 11, number: 2))

        XCTAssertEqual(sut.selectedSeason?.id, 11)
        XCTAssertEqual(useCase.requestedEpisodesSeasonIds, [11])
        XCTAssertEqual(sut.episodes.map(\.id), [110])
    }

    func test_getGenresString_joinsGenresWithComma() {
        let sut = ShowDetailViewModel(show: .fixture(id: 1, genres: ["Drama", "Thriller"]), useCase: ShowsUseCaseStub())

        XCTAssertEqual(sut.getGenresString(), "Drama, Thriller")
    }

    func test_getFormattedSummary_stripsHTMLTags() {
        let sut = ShowDetailViewModel(show: .fixture(id: 1, summary: "<p>A <b>great</b> show.</p>"), useCase: ShowsUseCaseStub())

        XCTAssertEqual(sut.getFormattedSummary(), "A great show.")
    }

    func test_formatting_withoutShow_returnsEmptyStrings() {
        let (sut, _) = makeSUT(showId: 1)

        XCTAssertEqual(sut.getGenresString(), "")
        XCTAssertEqual(sut.getFormattedSummary(), "")
    }

    func test_trackScreenView_tracksShowDetailWithShowId() {
        let tracker = TrackerSpy()
        let (sut, _) = makeSUT(showId: 1, tracker: tracker)

        sut.trackScreenView()

        XCTAssertEqual(tracker.events, [.screenView(.showDetail, itemId: 1)])
    }

    func test_loadData_whenShowFailsWithoutInitialShow_tracksLoadFailed() async {
        let tracker = TrackerSpy()
        let (sut, useCase) = makeSUT(showId: 1, tracker: tracker)
        useCase.fetchShowByIdResult = .failure(StubError.failure)

        await sut.loadData()

        XCTAssertEqual(tracker.events, [.loadFailed(.showDetail)])
    }

    func test_loadData_whenShowRefreshFailsWithInitialShow_doesNotTrackLoadFailed() async {
        let tracker = TrackerSpy()
        let useCase = ShowsUseCaseStub()
        let sut = ShowDetailViewModel(show: .fixture(id: 1), useCase: useCase, tracker: tracker)
        useCase.fetchShowByIdResult = .failure(StubError.failure)

        await sut.loadData()

        XCTAssertTrue(tracker.events.isEmpty)
    }

    func test_selectSeason_tracksSeasonSelection() async {
        let tracker = TrackerSpy()
        let (sut, _) = makeSUT(showId: 1, tracker: tracker)

        await sut.selectSeason(season: .fixture(id: 11, number: 2))

        XCTAssertEqual(tracker.events, [.selectSeason(showId: 1, season: 2)])
    }

    func test_retry_tracksRetryAndReloadsShow() async {
        let tracker = TrackerSpy()
        let (sut, useCase) = makeSUT(showId: 1, tracker: tracker)
        useCase.fetchShowByIdResult = .success(.fixture(id: 1))

        await sut.retry()

        XCTAssertEqual(tracker.events, [.retry(.showDetail)])
        XCTAssertEqual(useCase.requestedShowIds, [1])
        XCTAssertEqual(sut.show?.id, 1)
    }

    private func makeSUT(showId: Int, tracker: TrackerSpy = TrackerSpy()) -> (sut: ShowDetailViewModel, useCase: ShowsUseCaseStub) {
        let useCase = ShowsUseCaseStub()
        return (ShowDetailViewModel(showId: showId, useCase: useCase, tracker: tracker), useCase)
    }
}
