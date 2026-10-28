//
//  EndpointTests.swift
//  NetworkingTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
@testable import Networking

final class EndpointTests: XCTestCase {

    func test_makeRequest_combinesBaseURLAndPath() throws {
        let request = try EndpointStub().makeRequest()

        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/items")
    }

    func test_makeRequest_appendsPercentEncodedQueryItems() throws {
        let endpoint = EndpointStub(queryItems: [
            URLQueryItem(name: "q", value: "breaking bad"),
            URLQueryItem(name: "page", value: "2")
        ])

        let request = try endpoint.makeRequest()

        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/items?q=breaking%20bad&page=2")
    }

    func test_makeRequest_withoutQueryItems_hasNoQueryString() throws {
        let request = try EndpointStub(queryItems: nil).makeRequest()

        XCTAssertNil(request.url?.query)
    }

    func test_makeRequest_usesEndpointHTTPMethod() throws {
        for method in [HTTPMethod.GET, .POST, .PUT, .DELETE] {
            let request = try EndpointStub(method: method).makeRequest()

            XCTAssertEqual(request.httpMethod, method.rawValue)
        }
    }

    func test_makeRequest_withMalformedURL_throwsInvalidURL() {
        let endpoint = EndpointStub(baseURL: "ht tp://malformed")

        XCTAssertThrowsError(try endpoint.makeRequest()) { error in
            guard case .invalidURL = error as? NetworkError else {
                return XCTFail("Expected NetworkError.invalidURL, got \(error)")
            }
        }
    }
}
