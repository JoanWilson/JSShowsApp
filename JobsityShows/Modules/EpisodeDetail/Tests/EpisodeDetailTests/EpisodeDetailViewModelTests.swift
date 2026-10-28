//
//  EpisodeDetailViewModelTests.swift
//  EpisodeDetailTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
import Domain
@testable import EpisodeDetail

@MainActor
final class EpisodeDetailViewModelTests: XCTestCase {

    func test_initWithEpisode_exposesEpisodeBeforeLoading() {
        let episode = Episode.fixture(id: 100)

        let sut = EpisodeDetailViewModel(episode: episode, useCase: ShowsUseCaseStub())

        XCTAssertEqual(sut.episode, episode)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadData_success_setsEpisode() async {
        let useCase = ShowsUseCaseStub()
        useCase.fetchEpisodeByIdResult = .success(.fixture(id: 100, name: "Pilot"))
        let sut = EpisodeDetailViewModel(episodeId: 100, useCase: useCase)

        await sut.loadData()

        XCTAssertEqual(useCase.requestedEpisodeIds, [100])
        XCTAssertEqual(sut.episode?.name, "Pilot")
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadData_failure_setsErrorAndKeepsInitialEpisode() async {
        let initialEpisode = Episode.fixture(id: 100)
        let useCase = ShowsUseCaseStub()
        useCase.fetchEpisodeByIdResult = .failure(StubError.failure)
        let sut = EpisodeDetailViewModel(episode: initialEpisode, useCase: useCase)

        await sut.loadData()

        XCTAssertEqual(sut.error as? StubError, .failure)
        XCTAssertEqual(sut.episode, initialEpisode)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadData_retryAfterFailure_clearsError() async {
        let useCase = ShowsUseCaseStub()
        useCase.fetchEpisodeByIdResult = .failure(StubError.failure)
        let sut = EpisodeDetailViewModel(episodeId: 100, useCase: useCase)
        await sut.loadData()

        useCase.fetchEpisodeByIdResult = .success(.fixture(id: 100))
        await sut.loadData()

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.episode?.id, 100)
    }
}
