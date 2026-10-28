//
//  XCUIApplication+.swift
//  JobsityShowsUITests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest

extension XCUIApplication {

    static let timeout: TimeInterval = 5

    @MainActor
    static func launchWithStubs(failingPath: String? = nil) -> XCUIApplication {
        let app: XCUIApplication = XCUIApplication()
        app.launchArguments = ["-UITests", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        if let failingPath: String = failingPath {
            app.launchEnvironment["STUB_FAILING_PATH"] = failingPath
        }
        app.launch()
        return app
    }

    @MainActor
    func element(containing text: String) -> XCUIElement {
        descendants(matching: .any)
            .matching(NSPredicate(format: "label CONTAINS %@", text))
            .firstMatch
    }

    @MainActor
    func showCell(named name: String) -> XCUIElement {
        collectionViews.cells.containing(.staticText, identifier: name).firstMatch
    }

    @MainActor
    func openShowDetail(named name: String) {
        let cell: XCUIElement = showCell(named: name)
        XCTAssertTrue(cell.waitForExistence(timeout: Self.timeout))
        cell.tap()
        XCTAssertTrue(navigationBars[name].waitForExistence(timeout: Self.timeout))
    }

    @MainActor
    func openEpisode(named name: String) {
        let episode: XCUIElement = element(containing: name)
        XCTAssertTrue(episode.waitForExistence(timeout: Self.timeout))
        episode.tap()
        XCTAssertTrue(navigationBars["Episode Details"].waitForExistence(timeout: Self.timeout))
    }
}
