//
//  NetworkErrorTests.swift
//  NetworkingTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
@testable import Networking

final class NetworkErrorTests: XCTestCase {

    func test_localizedDescription_usesErrorDescription() {
        XCTAssertEqual(NetworkError.invalidURL.localizedDescription, "Invalid URL.")
        XCTAssertEqual(NetworkError.invalidResponse.localizedDescription, "Invalid server response.")
        XCTAssertEqual(NetworkError.statusCode(500).localizedDescription, "Unexpected HTTP status code: 500.")
        XCTAssertEqual(NetworkError.noData.localizedDescription, "No data received.")
    }
}
