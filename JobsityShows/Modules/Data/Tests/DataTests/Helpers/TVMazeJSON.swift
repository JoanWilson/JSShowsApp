//
//  TVMazeJSON.swift
//  DataTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import Foundation
@testable import Data

enum TVMazeJSON {

    static let show = """
    {
        "id": 1,
        "url": "https://www.tvmaze.com/shows/1/under-the-dome",
        "name": "Under the Dome",
        "type": "Scripted",
        "genres": ["Drama", "Science-Fiction", "Thriller"],
        "schedule": { "time": "22:00", "days": ["Thursday"] },
        "image": {
            "medium": "https://static.tvmaze.com/medium/1.jpg",
            "original": "https://static.tvmaze.com/original/1.jpg"
        },
        "summary": "<p><b>Under the Dome</b> is the story of a small town.</p>"
    }
    """

    static let showWithoutOptionals = """
    {
        "id": 2,
        "name": "Person of Interest",
        "genres": [],
        "schedule": { "time": "", "days": [] },
        "image": null,
        "summary": null
    }
    """

    static let shows = "[\(show), \(showWithoutOptionals)]"

    static let searchResults = """
    [
        { "score": 0.91, "show": \(show) },
        { "score": 0.45, "show": \(showWithoutOptionals) }
    ]
    """

    static let season = """
    {
        "id": 10,
        "url": "https://www.tvmaze.com/seasons/10",
        "number": 1,
        "episodeOrder": 13,
        "image": {
            "medium": "https://static.tvmaze.com/medium/10.jpg",
            "original": "https://static.tvmaze.com/original/10.jpg"
        }
    }
    """

    static let seasonWithoutEpisodeOrder = """
    {
        "id": 11,
        "number": 2,
        "episodeOrder": null,
        "image": null
    }
    """

    static let seasons = "[\(season), \(seasonWithoutEpisodeOrder)]"

    static let episode = """
    {
        "id": 100,
        "url": "https://www.tvmaze.com/episodes/100",
        "name": "Pilot",
        "season": 1,
        "number": 1,
        "runtime": 60,
        "image": {
            "medium": "https://static.tvmaze.com/medium/100.jpg",
            "original": "https://static.tvmaze.com/original/100.jpg"
        },
        "summary": "<p>When the <i>dome</i> falls, the town is cut off.</p>"
    }
    """

    static let episodeWithoutOptionals = """
    {
        "id": 101,
        "name": "The Fire",
        "season": 1,
        "number": 2,
        "runtime": null,
        "image": null,
        "summary": null
    }
    """

    static let episodes = "[\(episode), \(episodeWithoutOptionals)]"

    static func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder().decode(type, from: Foundation.Data(json.utf8))
    }
}
