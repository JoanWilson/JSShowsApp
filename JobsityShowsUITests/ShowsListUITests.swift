//
//  ShowsListUITests.swift
//  JobsityShowsUITests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest

final class ShowsListUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func test_launch_showsShowsList() {
        let app: XCUIApplication = .launchWithStubs()

        XCTAssertTrue(app.navigationBars["Shows"].waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.showCell(named: "Under the Dome").waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.showCell(named: "Person of Interest").exists)
    }

    @MainActor
    func test_search_showsOnlyMatchingShows() {
        let app: XCUIApplication = .launchWithStubs()
        XCTAssertTrue(app.showCell(named: "Person of Interest").waitForExistence(timeout: XCUIApplication.timeout))

        search("dome", in: app)

        XCTAssertTrue(app.showCell(named: "Person of Interest").waitForNonExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.showCell(named: "Under the Dome").exists)
    }

    @MainActor
    func test_search_withoutResults_showsEmptyList() {
        let app: XCUIApplication = .launchWithStubs()
        XCTAssertTrue(app.showCell(named: "Under the Dome").waitForExistence(timeout: XCUIApplication.timeout))

        search("friends", in: app)

        XCTAssertTrue(app.showCell(named: "Under the Dome").waitForNonExistence(timeout: XCUIApplication.timeout))
        XCTAssertEqual(app.collectionViews.cells.count, 0)
    }

    @MainActor
    func test_cancelSearch_showsAllShowsAgain() {
        let app: XCUIApplication = .launchWithStubs()
        XCTAssertTrue(app.showCell(named: "Person of Interest").waitForExistence(timeout: XCUIApplication.timeout))
        search("dome", in: app)
        XCTAssertTrue(app.showCell(named: "Person of Interest").waitForNonExistence(timeout: XCUIApplication.timeout))

        app.buttons.matching(NSPredicate(format: "label IN %@", ["Cancel", "close"])).firstMatch.tap()

        XCTAssertTrue(app.showCell(named: "Person of Interest").waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertTrue(app.showCell(named: "Under the Dome").exists)
    }

    @MainActor
    func test_serverError_showsEmptyMessage() {
        let app: XCUIApplication = .launchWithStubs(failingPath: "/")

        XCTAssertTrue(app.staticTexts["No shows available"].waitForExistence(timeout: XCUIApplication.timeout))
        XCTAssertFalse(app.showCell(named: "Under the Dome").exists)
    }

    @MainActor
    func test_tapShow_opensShowDetail() {
        let app: XCUIApplication = .launchWithStubs()

        app.openShowDetail(named: "Under the Dome")

        XCTAssertTrue(app.element(containing: "Pilot").waitForExistence(timeout: XCUIApplication.timeout))
    }

    @MainActor
    private func search(_ text: String, in app: XCUIApplication) {
        let searchField: XCUIElement = app.searchFields["Search Shows"]
        XCTAssertTrue(searchField.waitForExistence(timeout: XCUIApplication.timeout))
        searchField.tap()
        searchField.typeText(text)
    }
}
