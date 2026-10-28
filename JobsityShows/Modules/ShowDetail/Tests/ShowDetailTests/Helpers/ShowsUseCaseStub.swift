//
//  ShowsUseCaseStub.swift
//  ShowDetailTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import Foundation
import Domain

enum StubError: Error {
    case failure
    case notStubbed
}

final class ShowsUseCaseStub: ShowsUseCaseProtocol, @unchecked Sendable {

    var fetchShowByIdResult: Result<Show, Error> = .failure(StubError.notStubbed)
    var fetchSeasonsResult: Result<[Season], Error> = .success([])
    var fetchEpisodesHandler: (Int) throws -> [Episode] = { _ in [] }

    private(set) var requestedShowIds: [Int] = []
    private(set) var requestedSeasonsShowIds: [Int] = []
    private(set) var requestedEpisodesSeasonIds: [Int] = []

    func fetchShowById(id: Int) async throws -> Show {
        requestedShowIds.append(id)
        return try fetchShowByIdResult.get()
    }

    func fetchSeasons(showId: Int) async throws -> [Season] {
        requestedSeasonsShowIds.append(showId)
        return try fetchSeasonsResult.get()
    }

    func fetchEpisodes(seasonId: Int) async throws -> [Episode] {
        requestedEpisodesSeasonIds.append(seasonId)
        return try fetchEpisodesHandler(seasonId)
    }

    func fetchShows(page: Int) async throws -> [Show] { throw StubError.notStubbed }
    func searchShows(query: String) async throws -> [Show] { throw StubError.notStubbed }
    func fetchEpisodeById(episodeId: Int) async throws -> Episode { throw StubError.notStubbed }
}

extension Show {
    static func fixture(id: Int, genres: [String] = [], summary: String? = nil) -> Show {
        Show(
            id: id,
            name: "Show \(id)",
            genres: genres,
            schedule: Show.Schedule(time: "", days: []),
            image: nil,
            summary: summary
        )
    }
}

extension Season {
    static func fixture(id: Int, number: Int = 1) -> Season {
        Season(id: id, number: number, episodeCount: 0, image: nil)
    }
}

extension Episode {
    static func fixture(id: Int, season: Int = 1) -> Episode {
        Episode(id: id, name: "Episode \(id)", season: season, number: 1, summary: nil, image: nil, runtime: nil)
    }
}
