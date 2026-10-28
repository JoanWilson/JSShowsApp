//
//  StringRemovingHTMLTagsTests.swift
//  ExtensionsTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
@testable import Extensions

final class StringRemovingHTMLTagsTests: XCTestCase {

    func test_removingHTMLTags_stripsSimpleTags() {
        let html = "<p>Under the <b>Dome</b> is a show.</p>"

        XCTAssertEqual(html.removingHTMLTags(), "Under the Dome is a show.")
    }

    func test_removingHTMLTags_stripsTagsWithAttributes() {
        let html = "<a href=\"https://tvmaze.com\" class=\"link\">TVMaze</a>"

        XCTAssertEqual(html.removingHTMLTags(), "TVMaze")
    }

    func test_removingHTMLTags_stripsSelfClosingTags() {
        let html = "First line<br/>Second line<br />"

        XCTAssertEqual(html.removingHTMLTags(), "First lineSecond line")
    }

    func test_removingHTMLTags_keepsPlainTextUnchanged() {
        XCTAssertEqual("No tags here".removingHTMLTags(), "No tags here")
    }

    func test_removingHTMLTags_returnsEmptyStringForEmptyInput() {
        XCTAssertEqual("".removingHTMLTags(), "")
    }
}
