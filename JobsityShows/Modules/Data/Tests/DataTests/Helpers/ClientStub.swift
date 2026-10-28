//
//  ClientStub.swift
//  DataTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import Foundation
import Networking

final class ClientStub: Client, @unchecked Sendable {

    var result: Result<String, Error> = .success("[]")
    private(set) var requestedEndpoints: [Endpoint] = []

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        requestedEndpoints.append(endpoint)
        let json = try result.get()
        return try JSONDecoder().decode(T.self, from: Foundation.Data(json.utf8))
    }

    func request(_ endpoint: Endpoint) async throws {
        requestedEndpoints.append(endpoint)
        _ = try result.get()
    }
}
