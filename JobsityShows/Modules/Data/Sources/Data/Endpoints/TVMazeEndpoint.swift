//
//  MaziAPI.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation
import Network

public enum TVMazeEndpoint {
    case show(id: Int)
    case shows(page: Int)
    case searchShows(query: String)
    case seasons(showId: Int)
    case episodes(seasonId: Int)
    case episode(episodeId: Int)
}

extension TVMazeEndpoint: Endpoint {
    public var baseURL: String { "https://api.tvmaze.com" }

    public var path: String {
        switch self {
        case .show(id: let id): return "/shows/\(id)"
        case .shows: return "/shows"
        case .searchShows: return "/search/shows"
        case .seasons(let showId): return "/shows/\(showId)/seasons"
        case .episode(let episodeId): return "/episodes/\(episodeId)"
        case .episodes(let seasonId): return "/seasons/\(seasonId)/episodes"
        }
    }

    public var method: HTTPMethod { .GET }

    public var queryItems: [URLQueryItem]? {
        switch self {
        case .shows(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .searchShows(let query):
            return [URLQueryItem(name: "q", value: query)]
        case .seasons, .episodes, .show, .episode:
            return nil
        }
    }
}
