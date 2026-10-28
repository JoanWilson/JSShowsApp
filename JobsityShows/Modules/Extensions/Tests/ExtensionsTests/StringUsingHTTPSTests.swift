//
//  StringUsingHTTPSTests.swift
//  ExtensionsTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
@testable import Extensions

final class StringUsingHTTPSTests: XCTestCase {

    func test_usingHTTPS_upgradesHTTPURL() {
        let url = "http://static.tvmaze.com/uploads/images/original_untouched/1/4661.jpg"

        XCTAssertEqual(url.usingHTTPS(), "https://static.tvmaze.com/uploads/images/original_untouched/1/4661.jpg")
    }

    func test_usingHTTPS_keepsHTTPSURLUnchanged() {
        let url = "https://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg"

        XCTAssertEqual(url.usingHTTPS(), url)
    }

    func test_usingHTTPS_keepsNonHTTPStringUnchanged() {
        XCTAssertEqual("static.tvmaze.com/http://".usingHTTPS(), "static.tvmaze.com/http://")
        XCTAssertEqual("".usingHTTPS(), "")
    }
}
