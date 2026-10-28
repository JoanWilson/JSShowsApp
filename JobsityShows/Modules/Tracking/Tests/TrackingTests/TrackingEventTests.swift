//
//  TrackingEventTests.swift
//  TrackingTests
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

import XCTest
@testable import Tracking

final class TrackingEventTests: XCTestCase {

    func test_screenView_withoutItem_hasOnlyScreenName() {
        XCTAssertEqual(
            TrackingEvent.screenView(.showsList),
            TrackingEvent(name: "screen_view", parameters: ["screen_name": "shows_list"])
        )
    }

    func test_screenView_withItem_addsItemId() {
        XCTAssertEqual(
            TrackingEvent.screenView(.episodeDetail, itemId: 100),
            TrackingEvent(name: "screen_view", parameters: ["screen_name": "episode_detail", "item_id": "100"])
        )
    }

    func test_search_hasSearchTerm() {
        XCTAssertEqual(
            TrackingEvent.search(term: "dome"),
            TrackingEvent(name: "search", parameters: ["search_term": "dome"])
        )
    }

    func test_selectShow_hasContentAndSource() {
        XCTAssertEqual(
            TrackingEvent.selectShow(id: 1, name: "Under the Dome", fromSearch: false),
            TrackingEvent(name: "select_content", parameters: [
                "content_type": "show",
                "item_id": "1",
                "item_name": "Under the Dome",
                "source": "list"
            ])
        )
        XCTAssertEqual(TrackingEvent.selectShow(id: 1, name: "Under the Dome", fromSearch: true).parameters["source"], "search")
    }

    func test_selectSeason_hasShowAndSeason() {
        XCTAssertEqual(
            TrackingEvent.selectSeason(showId: 1, season: 2),
            TrackingEvent(name: "select_season", parameters: ["item_id": "1", "season": "2"])
        )
    }

    func test_loadFailedAndRetry_haveScreenName() {
        XCTAssertEqual(
            TrackingEvent.loadFailed(.showDetail),
            TrackingEvent(name: "load_failed", parameters: ["screen_name": "show_detail"])
        )
        XCTAssertEqual(
            TrackingEvent.retry(.showDetail),
            TrackingEvent(name: "retry", parameters: ["screen_name": "show_detail"])
        )
    }

    func test_eventNamesAndParameters_followFirebaseLimits() {
        let events: [TrackingEvent] = [
            .screenView(.showDetail, itemId: 1),
            .search(term: "dome"),
            .selectShow(id: 1, name: "Under the Dome", fromSearch: true),
            .selectSeason(showId: 1, season: 1),
            .loadFailed(.showsList),
            .retry(.episodeDetail)
        ]
        let validName = try? NSRegularExpression(pattern: "^[a-z][a-z0-9_]{0,39}$")

        for event in events {
            let names = [event.name] + Array(event.parameters.keys)
            for name in names {
                let range = NSRange(name.startIndex..., in: name)
                XCTAssertNotNil(validName?.firstMatch(in: name, range: range), "Invalid Firebase name: \(name)")
            }
            XCTAssertLessThanOrEqual(event.parameters.count, 25, event.name)
        }
    }
}
