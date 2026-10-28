//
//  TVMazeStubResponses.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

#if DEBUG
import Foundation

enum TVMazeStubResponses {

    static func response(for url: URL) -> (statusCode: Int, body: String) {
        let path: [String] = url.path.split(separator: "/").map(String.init)
        let queryItems: [URLQueryItem] = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []

        switch path.count {
        case 1 where path[0] == "shows":
            let page: String? = queryItems.first { $0.name == "page" }?.value
            return page == "1" ? (200, "[\(underTheDome), \(personOfInterest)]") : (404, "")
        case 2 where path[0] == "search":
            let query: String = queryItems.first { $0.name == "q" }?.value?.lowercased() ?? ""
            return (200, query.contains("dome") ? "[{ \"score\": 0.9, \"show\": \(underTheDome) }]" : "[]")
        case 2 where path[0] == "shows":
            return found(shows[path[1]])
        case 2 where path[0] == "episodes":
            return found(episodes[path[1]])
        case 3 where path[0] == "shows" && path[2] == "seasons":
            return (200, seasons[path[1]] ?? "[]")
        case 3 where path[0] == "seasons" && path[2] == "episodes":
            return (200, episodesBySeason[path[1]] ?? "[]")
        default:
            return (404, "")
        }
    }

    private static func found(_ body: String?) -> (statusCode: Int, body: String) {
        guard let body: String = body else { return (404, "") }
        return (200, body)
    }

    private static let underTheDome: String = """
    {
        "id": 1,
        "name": "Under the Dome",
        "genres": ["Drama", "Science-Fiction", "Thriller"],
        "schedule": { "time": "22:00", "days": ["Thursday"] },
        "image": null,
        "summary": "<p><b>Under the Dome</b> is the story of a small town that is suddenly sealed off from the rest of the world by an enormous transparent dome.</p>"
    }
    """

    private static let personOfInterest: String = """
    {
        "id": 2,
        "name": "Person of Interest",
        "genres": ["Action", "Crime", "Science-Fiction"],
        "schedule": { "time": "22:00", "days": ["Tuesday"] },
        "image": null,
        "summary": "<p>You are being watched. The government has a secret system that spies on you every hour of every day.</p>"
    }
    """

    private static let pilot: String = """
    {
        "id": 1,
        "name": "Pilot",
        "season": 1,
        "number": 1,
        "runtime": 60,
        "image": null,
        "summary": "<p>The residents of Chester's Mill find themselves trapped under a massive transparent dome.</p>"
    }
    """

    private static let theFire: String = """
    {
        "id": 2,
        "name": "The Fire",
        "season": 1,
        "number": 2,
        "runtime": 60,
        "image": null,
        "summary": null
    }
    """

    private static let headsWillRoll: String = """
    {
        "id": 14,
        "name": "Heads Will Roll",
        "season": 2,
        "number": 1,
        "runtime": 60,
        "image": null,
        "summary": "<p>Barbie and Julia look for a way to get the town out of the dome.</p>"
    }
    """

    private static let shows: [String: String] = [
        "1": underTheDome,
        "2": personOfInterest
    ]

    private static let seasons: [String: String] = [
        "1": """
        [
            { "id": 1, "number": 1, "episodeOrder": 13, "image": null },
            { "id": 2, "number": 2, "episodeOrder": 13, "image": null }
        ]
        """
    ]

    private static let episodesBySeason: [String: String] = [
        "1": "[\(pilot), \(theFire)]",
        "2": "[\(headsWillRoll)]"
    ]

    private static let episodes: [String: String] = [
        "1": pilot,
        "2": theFire,
        "14": headsWillRoll
    ]
}
#endif
