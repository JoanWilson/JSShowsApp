//
//  ShowDetailUITests.swift
//  JobsityShowsUITests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest

final class ShowDetailUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func test_showDetail_showsSummaryGenresAndSchedule() {
        let app: XCUIApplication = .launchWithStubs()

        app.openShowDetail(named: "Under the Dome")

        XCTAssertTrue(app.element(containing: "is the story of a small town").waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.staticTexts["Summary"].exists)
        XCTAssertTrue(app.staticTexts["Drama"].exists)
        XCTAssertTrue(app.staticTexts["Thriller"].exists)
        XCTAssertTrue(app.staticTexts["Schedule:"].exists)
        XCTAssertTrue(app.staticTexts["Time: 22:00"].exists)
    }

    @MainActor
    func test_showDetail_listsFirstSeasonEpisodes() {
        let app: XCUIApplication = .launchWithStubs()

        app.openShowDetail(named: "Under the Dome")

        XCTAssertTrue(app.element(containing: "Pilot").waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.element(containing: "S1E1").exists)
        XCTAssertTrue(app.element(containing: "The Fire").exists)
        XCTAssertTrue(app.element(containing: "S1E2").exists)
        XCTAssertTrue(app.element(containing: "Season 1").exists)
    }

    @MainActor
    func test_selectSeason_showsSelectedSeasonEpisodes() {
        let app: XCUIApplication = .launchWithStubs()
        app.openShowDetail(named: "Under the Dome")
        XCTAssertTrue(app.element(containing: "Pilot").waitForExistence(timeout: XCUIApplication.timeout))

        app.element(containing: "Season 1").tap()
        let secondSeason: XCUIElement = app.buttons["Season 2"]
        XCTAssertTrue(secondSeason.waitForExistence(timeout: XCUIApplication.timeout))
        secondSeason.tap()

        XCTAssertTrue(app.element(containing: "Heads Will Roll").waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.element(containing: "S2E1").exists)
        XCTAssertTrue(app.element(containing: "Pilot").waitForNonExistence(timeout: XCUIApplication.timeout))
    }

    @MainActor
    func test_backButton_returnsToShowsList() {
        let app: XCUIApplication = .launchWithStubs()
        app.openShowDetail(named: "Under the Dome")

        app.navigationBars.buttons["Shows"].tap()

        XCTAssertTrue(app.navigationBars["Shows"].waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.showCell(named: "Person of Interest").exists)
    }
}
