//
//  ShowsRepository.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import Foundation
import Domain
import Network

public final class ShowsRepository: ShowsUseCaseProtocol {

    private let client: Client

    public init(client: Client = HTTPClient()) {
        self.client = client
    }

    public func fetchShows(page: Int) async throws -> [Show] {
        let endpoint = TVMazeEndpoint.shows(page: page)
        return try await client.request(endpoint)
    }

    public func fetchShowById(id: Int) async throws -> Show {
        let endpoint = TVMazeEndpoint.show(id: id)
        return try await client.request(endpoint)
    }

    public func searchShows(query: String) async throws -> [Show] {
        let endpoint = TVMazeEndpoint.searchShows(query: query)
        let results: [SearchResultsDTO] = try await client.request(endpoint)
        return results.map { $0.show.toDomain() }
    }

    public func fetchSeasons(showId: Int) async throws -> [Season] {
        let endpoint = TVMazeEndpoint.seasons(showId: showId)
        let seasons: [SeasonDTO] = try await client.request(endpoint)
        return seasons.map { $0.toDomain() }
    }

    public func fetchEpisodes(seasonId: Int) async throws -> [Episode] {
        let endpoint = TVMazeEndpoint.episodes(seasonId: seasonId)
        let episodes: [EpisodeDTO] = try await client.request(endpoint)
        return episodes.map { $0.toDomain() }
    }

    public func fetchEpisodeById(episodeId: Int) async throws -> Episode {
        let endpoint = TVMazeEndpoint.episode(episodeId: episodeId)
        let episode: EpisodeDTO = try await client.request(endpoint)
        return episode.toDomain()
    }
}

