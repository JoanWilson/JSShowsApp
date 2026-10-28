//
//  DTOMappingTests.swift
//  DataTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
import Domain
@testable import Data

final class DTOMappingTests: XCTestCase {

    func test_showDTO_toDomain_mapsAllFieldsAndStripsHTMLFromSummary() throws {
        let show = try TVMazeJSON.decode(ShowDTO.self, from: TVMazeJSON.show).toDomain()

        XCTAssertEqual(show, Show(
            id: 1,
            name: "Under the Dome",
            genres: ["Drama", "Science-Fiction", "Thriller"],
            schedule: Show.Schedule(time: "22:00", days: ["Thursday"]),
            image: Show.Image(
                medium: "https://static.tvmaze.com/medium/1.jpg",
                original: "https://static.tvmaze.com/original/1.jpg"
            ),
            summary: "Under the Dome is the story of a small town."
        ))
    }

    func test_showDTO_toDomain_keepsMissingOptionalsAsNil() throws {
        let show = try TVMazeJSON.decode(ShowDTO.self, from: TVMazeJSON.showWithoutOptionals).toDomain()

        XCTAssertNil(show.image)
        XCTAssertNil(show.summary)
    }

    func test_imageDTO_toDomain_upgradesHTTPURLsToHTTPS() {
        let image = ShowDTO.ImageDTO(
            medium: "http://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg",
            original: "http://static.tvmaze.com/uploads/images/original_untouched/1/4661.jpg"
        ).toDomain()

        XCTAssertEqual(image, Show.Image(
            medium: "https://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg",
            original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4661.jpg"
        ))
    }

    func test_showDTO_toDomain_upgradesHTTPImageURLsToHTTPS() {
        let show = ShowDTO(
            id: 1,
            name: "Under the Dome",
            genres: [],
            schedule: ShowDTO.ScheduleDTO(time: "", days: []),
            image: ShowDTO.ImageDTO(medium: "http://static.tvmaze.com/m.jpg", original: "http://static.tvmaze.com/o.jpg"),
            summary: nil
        ).toDomain()

        XCTAssertEqual(show.image, Show.Image(medium: "https://static.tvmaze.com/m.jpg", original: "https://static.tvmaze.com/o.jpg"))
    }

    func test_searchResultsDTO_toDomain_mapsScoreAndShow() throws {
        let results = try TVMazeJSON.decode([SearchResultsDTO].self, from: TVMazeJSON.searchResults)
            .map { $0.toDomain() }

        XCTAssertEqual(results.map(\.score), [0.91, 0.45])
        XCTAssertEqual(results.map(\.show.id), [1, 2])
        XCTAssertEqual(results.first?.show.summary, "Under the Dome is the story of a small town.")
    }

    func test_seasonDTO_toDomain_mapsEpisodeOrderToEpisodeCount() throws {
        let season = try TVMazeJSON.decode(SeasonDTO.self, from: TVMazeJSON.season).toDomain()

        XCTAssertEqual(season, Season(
            id: 10,
            number: 1,
            episodeCount: 13,
            image: Show.Image(
                medium: "https://static.tvmaze.com/medium/10.jpg",
                original: "https://static.tvmaze.com/original/10.jpg"
            )
        ))
    }

    func test_seasonDTO_toDomain_withoutEpisodeOrder_defaultsEpisodeCountToZero() throws {
        let season = try TVMazeJSON.decode(SeasonDTO.self, from: TVMazeJSON.seasonWithoutEpisodeOrder).toDomain()

        XCTAssertEqual(season.episodeCount, 0)
        XCTAssertNil(season.image)
    }

    func test_episodeDTO_toDomain_mapsAllFieldsAndStripsHTMLFromSummary() throws {
        let episode = try TVMazeJSON.decode(EpisodeDTO.self, from: TVMazeJSON.episode).toDomain()

        XCTAssertEqual(episode, Episode(
            id: 100,
            name: "Pilot",
            season: 1,
            number: 1,
            summary: "When the dome falls, the town is cut off.",
            image: Show.Image(
                medium: "https://static.tvmaze.com/medium/100.jpg",
                original: "https://static.tvmaze.com/original/100.jpg"
            ),
            runtime: 60
        ))
    }

    func test_episodeDTO_toDomain_keepsMissingOptionalsAsNil() throws {
        let episode = try TVMazeJSON.decode(EpisodeDTO.self, from: TVMazeJSON.episodeWithoutOptionals).toDomain()

        XCTAssertNil(episode.summary)
        XCTAssertNil(episode.image)
        XCTAssertNil(episode.runtime)
    }
}
