//
//  ShowsUseCaseStub.swift
//  EpisodeDetailTests
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

    var fetchEpisodeByIdResult: Result<Episode, Error> = .failure(StubError.notStubbed)

    private(set) var requestedEpisodeIds: [Int] = []

    func fetchEpisodeById(episodeId: Int) async throws -> Episode {
        requestedEpisodeIds.append(episodeId)
        return try fetchEpisodeByIdResult.get()
    }

    func fetchShowById(id: Int) async throws -> Show { throw StubError.notStubbed }
    func fetchShows(page: Int) async throws -> [Show] { throw StubError.notStubbed }
    func searchShows(query: String) async throws -> [Show] { throw StubError.notStubbed }
    func fetchSeasons(showId: Int) async throws -> [Season] { throw StubError.notStubbed }
    func fetchEpisodes(seasonId: Int) async throws -> [Episode] { throw StubError.notStubbed }
}

extension Episode {
    static func fixture(id: Int, name: String? = nil) -> Episode {
        Episode(id: id, name: name ?? "Episode \(id)", season: 1, number: 1, summary: nil, image: nil, runtime: nil)
    }
}
