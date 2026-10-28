//
//  EpisodeDetailUITests.swift
//  JobsityShowsUITests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest

final class EpisodeDetailUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func test_episodeDetail_showsEpisodeInfoAndSummary() {
        let app: XCUIApplication = .launchWithStubs()
        app.openShowDetail(named: "Under the Dome")

        app.openEpisode(named: "Pilot")

        XCTAssertTrue(app.staticTexts["Season 1 • Episode 1"].waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.staticTexts["Pilot"].exists)
        XCTAssertTrue(app.staticTexts["Summary"].exists)
        XCTAssertTrue(app.element(containing: "trapped under a massive transparent dome").exists)
    }

    @MainActor
    func test_episodeWithoutSummary_showsPlaceholder() {
        let app: XCUIApplication = .launchWithStubs()
        app.openShowDetail(named: "Under the Dome")

        app.openEpisode(named: "The Fire")

        XCTAssertTrue(app.staticTexts["Season 1 • Episode 2"].waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.staticTexts["No summary available for this episode."].exists)
    }

    @MainActor
    func test_episodeLoadFailure_showsErrorWithRetry() {
        let app: XCUIApplication = .launchWithStubs(failingPath: "/episodes/")
        app.openShowDetail(named: "Under the Dome")

        app.openEpisode(named: "Pilot")

        XCTAssertTrue(app.staticTexts["Failed to load show details"].waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.buttons["Try Again"].exists)
    }

    @MainActor
    func test_backButton_returnsToShowDetail() {
        let app: XCUIApplication = .launchWithStubs()
        app.openShowDetail(named: "Under the Dome")
        app.openEpisode(named: "Pilot")

        app.navigationBars.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(app.navigationBars["Under the Dome"].waitForExistence(timeout: XCUIApplication.timeout))
    }
}
