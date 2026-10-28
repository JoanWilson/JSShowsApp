//
//  ShowsRepositoryTests.swift
//  DataTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
import Domain
import Networking
@testable import Data

final class ShowsRepositoryTests: XCTestCase {

    func test_fetchShows_requestsShowsEndpointForPage() async throws {
        let (sut, client) = makeSUT(json: TVMazeJSON.shows)

        _ = try await sut.fetchShows(page: 2)

        XCTAssertEqual(client.requestedEndpoints.count, 1)
        XCTAssertEqual(client.requestedEndpoints.first?.path, "/shows")
        XCTAssertEqual(client.requestedEndpoints.first?.queryItems, [URLQueryItem(name: "page", value: "2")])
    }

    func test_fetchShows_mapsShowsAndStripsHTMLFromSummary() async throws {
        let (sut, _) = makeSUT(json: TVMazeJSON.shows)

        let shows = try await sut.fetchShows(page: 0)

        XCTAssertEqual(shows.map(\.id), [1, 2])
        XCTAssertEqual(shows.first?.summary, "Under the Dome is the story of a small town.")
    }

    func test_fetchShows_propagatesClientError() async {
        let (sut, client) = makeSUT()
        client.result = .failure(NetworkError.statusCode(500))

        do {
            _ = try await sut.fetchShows(page: 0)
            XCTFail("Expected fetchShows to throw")
        } catch {
            guard case .statusCode(500) = error as? NetworkError else {
                return XCTFail("Expected .statusCode(500), got \(error)")
            }
        }
    }

    func test_fetchShowById_requestsShowEndpointAndStripsHTMLFromSummary() async throws {
        let (sut, client) = makeSUT(json: TVMazeJSON.show)

        let show = try await sut.fetchShowById(id: 1)

        XCTAssertEqual(client.requestedEndpoints.first?.path, "/shows/1")
        XCTAssertEqual(show.name, "Under the Dome")
        XCTAssertEqual(show.summary, "Under the Dome is the story of a small town.")
    }

    func test_searchShows_requestsSearchEndpointAndReturnsShowsInScoreOrder() async throws {
        let (sut, client) = makeSUT(json: TVMazeJSON.searchResults)

        let shows = try await sut.searchShows(query: "dome")

        XCTAssertEqual(client.requestedEndpoints.first?.path, "/search/shows")
        XCTAssertEqual(client.requestedEndpoints.first?.queryItems, [URLQueryItem(name: "q", value: "dome")])
        XCTAssertEqual(shows.map(\.id), [1, 2])
    }

    func test_fetchSeasons_requestsSeasonsEndpointAndMapsSeasons() async throws {
        let (sut, client) = makeSUT(json: TVMazeJSON.seasons)

        let seasons = try await sut.fetchSeasons(showId: 1)

        XCTAssertEqual(client.requestedEndpoints.first?.path, "/shows/1/seasons")
        XCTAssertEqual(seasons.map(\.id), [10, 11])
        XCTAssertEqual(seasons.map(\.episodeCount), [13, 0])
    }

    func test_fetchEpisodes_requestsEpisodesEndpointAndMapsEpisodes() async throws {
        let (sut, client) = makeSUT(json: TVMazeJSON.episodes)

        let episodes = try await sut.fetchEpisodes(seasonId: 10)

        XCTAssertEqual(client.requestedEndpoints.first?.path, "/seasons/10/episodes")
        XCTAssertEqual(episodes.map(\.id), [100, 101])
        XCTAssertEqual(episodes.first?.summary, "When the dome falls, the town is cut off.")
    }

    func test_fetchEpisodeById_requestsEpisodeEndpointAndMapsEpisode() async throws {
        let (sut, client) = makeSUT(json: TVMazeJSON.episode)

        let episode = try await sut.fetchEpisodeById(episodeId: 100)

        XCTAssertEqual(client.requestedEndpoints.first?.path, "/episodes/100")
        XCTAssertEqual(episode.name, "Pilot")
    }

    private func makeSUT(json: String = "[]") -> (sut: ShowsRepository, client: ClientStub) {
        let client = ClientStub()
        client.result = .success(json)
        return (ShowsRepository(client: client), client)
    }
}
