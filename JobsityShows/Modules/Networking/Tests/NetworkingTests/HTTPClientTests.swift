//
//  HTTPClientTests.swift
//  NetworkingTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import XCTest
@testable import Networking

final class HTTPClientTests: XCTestCase {

    private struct Item: Decodable, Equatable {
        let id: Int
        let name: String
    }

    private let url = URL(string: "https://api.example.com/items")!

    override func tearDown() {
        URLProtocolStub.reset()
        super.tearDown()
    }

    func test_request_onSuccess_decodesResponse() async throws {
        stub(statusCode: 200, json: #"{"id": 1, "name": "Under the Dome"}"#)

        let item: Item = try await makeSUT().request(EndpointStub())

        XCTAssertEqual(item, Item(id: 1, name: "Under the Dome"))
    }

    func test_request_sendsRequestThroughInjectedSession() async throws {
        stub(statusCode: 200, json: #"{"id": 1, "name": "Under the Dome"}"#)

        let _: Item = try await makeSUT().request(EndpointStub(method: .GET))

        XCTAssertEqual(URLProtocolStub.receivedRequests.count, 1)
        XCTAssertEqual(URLProtocolStub.receivedRequests.first?.url, url)
        XCTAssertEqual(URLProtocolStub.receivedRequests.first?.httpMethod, "GET")
    }

    func test_request_onNon2xxStatusCode_throwsStatusCode() async {
        stub(statusCode: 404, json: #"{"id": 1, "name": "Under the Dome"}"#)

        let error = await decodableRequestError()

        guard case .statusCode(404) = error else {
            return XCTFail("Expected .statusCode(404), got \(String(describing: error))")
        }
    }

    func test_request_onEmptyBody_throwsNoData() async {
        URLProtocolStub.stub(data: Data(), response: httpResponse(statusCode: 200))

        let error = await decodableRequestError()

        guard case .noData = error else {
            return XCTFail("Expected .noData, got \(String(describing: error))")
        }
    }

    func test_request_onInvalidJSON_throwsDecodingError() async {
        stub(statusCode: 200, json: #"{"unexpected": true}"#)

        let error = await decodableRequestError()

        guard case .decodingError = error else {
            return XCTFail("Expected .decodingError, got \(String(describing: error))")
        }
    }

    func test_request_onNonHTTPResponse_throwsInvalidResponse() async {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        URLProtocolStub.stub(data: Data("{}".utf8), response: response)

        let error = await decodableRequestError()

        guard case .invalidResponse = error else {
            return XCTFail("Expected .invalidResponse, got \(String(describing: error))")
        }
    }

    func test_request_onTransportError_throwsUnderlying() async {
        URLProtocolStub.stub(data: nil, response: nil, error: URLError(.notConnectedToInternet))

        let error = await decodableRequestError()

        guard case .underlying(let underlying) = error else {
            return XCTFail("Expected .underlying, got \(String(describing: error))")
        }
        XCTAssertEqual((underlying as? URLError)?.code, .notConnectedToInternet)
    }

    func test_requestWithoutBody_on2xx_succeeds() async throws {
        URLProtocolStub.stub(data: Data(), response: httpResponse(statusCode: 204))

        try await makeSUT().request(EndpointStub(method: .DELETE))

        XCTAssertEqual(URLProtocolStub.receivedRequests.first?.httpMethod, "DELETE")
    }

    func test_requestWithoutBody_onNon2xxStatusCode_throwsStatusCode() async {
        URLProtocolStub.stub(data: Data(), response: httpResponse(statusCode: 500))

        do {
            try await makeSUT().request(EndpointStub(method: .DELETE))
            XCTFail("Expected request to throw")
        } catch {
            guard case .statusCode(500) = error as? NetworkError else {
                return XCTFail("Expected .statusCode(500), got \(error)")
            }
        }
    }

    private func makeSUT() -> HTTPClient {
        HTTPClient(session: URLProtocolStub.makeSession())
    }

    private func httpResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }

    private func stub(statusCode: Int, json: String) {
        URLProtocolStub.stub(data: Data(json.utf8), response: httpResponse(statusCode: statusCode))
    }

    private func decodableRequestError() async -> NetworkError? {
        do {
            let _: Item = try await makeSUT().request(EndpointStub())
            XCTFail("Expected request to throw")
            return nil
        } catch {
            return error as? NetworkError
        }
    }
}
