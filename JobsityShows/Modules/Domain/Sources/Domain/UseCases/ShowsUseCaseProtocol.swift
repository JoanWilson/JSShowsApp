//
//  ShowsUseCaseProtocol.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation

public protocol ShowsUseCaseProtocol: Sendable {
    func fetchShowById(id: Int) async throws -> Show
    func fetchShows(page: Int) async throws -> [Show]
    func searchShows(query: String) async throws -> [Show]
    func fetchSeasons(showId: Int) async throws -> [Season]
    func fetchEpisodes(seasonId: Int) async throws -> [Episode]
}
