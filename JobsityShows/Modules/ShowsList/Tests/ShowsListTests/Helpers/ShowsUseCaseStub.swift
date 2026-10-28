//
//  ShowsUseCaseStub.swift
//  ShowsListTests
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

    var fetchShowsHandler: (Int) throws -> [Show] = { _ in [] }
    var searchShowsHandler: (String) throws -> [Show] = { _ in [] }

    private(set) var requestedPages: [Int] = []
    private(set) var searchedQueries: [String] = []

    func fetchShows(page: Int) async throws -> [Show] {
        requestedPages.append(page)
        return try fetchShowsHandler(page)
    }

    func searchShows(query: String) async throws -> [Show] {
        searchedQueries.append(query)
        return try searchShowsHandler(query)
    }

    func fetchShowById(id: Int) async throws -> Show { throw StubError.notStubbed }
    func fetchSeasons(showId: Int) async throws -> [Season] { throw StubError.notStubbed }
    func fetchEpisodeById(episodeId: Int) async throws -> Episode { throw StubError.notStubbed }
    func fetchEpisodes(seasonId: Int) async throws -> [Episode] { throw StubError.notStubbed }
}

extension Show {
    static func fixture(id: Int, name: String? = nil) -> Show {
        Show(
            id: id,
            name: name ?? "Show \(id)",
            genres: [],
            schedule: Show.Schedule(time: "", days: []),
            image: nil,
            summary: nil
        )
    }
}
