//
//  TrackingEvent.swift
//  Tracking
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

public struct TrackingEvent: Equatable, Sendable {
    public let name: String
    public let parameters: [String: String]

    public init(name: String, parameters: [String: String] = [:]) {
        self.name = name
        self.parameters = parameters
    }
}

public enum TrackingScreen: String, Sendable {
    case showsList = "shows_list"
    case showDetail = "show_detail"
    case episodeDetail = "episode_detail"
}

public extension TrackingEvent {
    static func screenView(_ screen: TrackingScreen, itemId: Int? = nil) -> TrackingEvent {
        var parameters: [String: String] = ["screen_name": screen.rawValue]
        parameters["item_id"] = itemId.map(String.init)
        return TrackingEvent(name: "screen_view", parameters: parameters)
    }

    static func search(term: String) -> TrackingEvent {
        TrackingEvent(name: "search", parameters: ["search_term": term])
    }

    static func selectShow(id: Int, name: String, fromSearch: Bool) -> TrackingEvent {
        TrackingEvent(name: "select_content", parameters: [
            "content_type": "show",
            "item_id": String(id),
            "item_name": name,
            "source": fromSearch ? "search" : "list"
        ])
    }

    static func selectSeason(showId: Int, season: Int) -> TrackingEvent {
        TrackingEvent(name: "select_season", parameters: [
            "item_id": String(showId),
            "season": String(season)
        ])
    }

    static func loadFailed(_ screen: TrackingScreen) -> TrackingEvent {
        TrackingEvent(name: "load_failed", parameters: ["screen_name": screen.rawValue])
    }

    static func retry(_ screen: TrackingScreen) -> TrackingEvent {
        TrackingEvent(name: "retry", parameters: ["screen_name": screen.rawValue])
    }

    static func connectionChanged(isConnected: Bool) -> TrackingEvent {
        TrackingEvent(name: isConnected ? "connection_restored" : "connection_lost")
    }
}
