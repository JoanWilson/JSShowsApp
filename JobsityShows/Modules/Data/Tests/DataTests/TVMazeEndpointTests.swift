//
//  TVMazeEndpointTests.swift
//  DataTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
import Networking
@testable import Data

final class TVMazeEndpointTests: XCTestCase {

    private let allEndpoints: [TVMazeEndpoint] = [
        .show(id: 1),
        .shows(page: 0),
        .searchShows(query: "dome"),
        .seasons(showId: 1),
        .episodes(seasonId: 10),
        .episode(episodeId: 100)
    ]

    func test_allEndpoints_useTVMazeBaseURLAndGET() {
        for endpoint in allEndpoints {
            XCTAssertEqual(endpoint.baseURL, "https://api.tvmaze.com", "\(endpoint)")
            XCTAssertEqual(endpoint.method, .GET, "\(endpoint)")
        }
    }

    func test_path_matchesTVMazeRoutes() {
        XCTAssertEqual(TVMazeEndpoint.show(id: 1).path, "/shows/1")
        XCTAssertEqual(TVMazeEndpoint.shows(page: 3).path, "/shows")
        XCTAssertEqual(TVMazeEndpoint.searchShows(query: "dome").path, "/search/shows")
        XCTAssertEqual(TVMazeEndpoint.seasons(showId: 1).path, "/shows/1/seasons")
        XCTAssertEqual(TVMazeEndpoint.episodes(seasonId: 10).path, "/seasons/10/episodes")
        XCTAssertEqual(TVMazeEndpoint.episode(episodeId: 100).path, "/episodes/100")
    }

    func test_queryItems_shows_containsPage() {
        XCTAssertEqual(TVMazeEndpoint.shows(page: 3).queryItems, [URLQueryItem(name: "page", value: "3")])
    }

    func test_queryItems_searchShows_containsQuery() {
        XCTAssertEqual(TVMazeEndpoint.searchShows(query: "dome").queryItems, [URLQueryItem(name: "q", value: "dome")])
    }

    func test_queryItems_endpointsWithoutParameters_areNil() {
        XCTAssertNil(TVMazeEndpoint.show(id: 1).queryItems)
        XCTAssertNil(TVMazeEndpoint.seasons(showId: 1).queryItems)
        XCTAssertNil(TVMazeEndpoint.episodes(seasonId: 10).queryItems)
        XCTAssertNil(TVMazeEndpoint.episode(episodeId: 100).queryItems)
    }

    func test_makeRequest_searchShows_buildsPercentEncodedURL() throws {
        let request = try TVMazeEndpoint.searchShows(query: "the office").makeRequest()

        XCTAssertEqual(request.url?.absoluteString, "https://api.tvmaze.com/search/shows?q=the%20office")
    }
}
