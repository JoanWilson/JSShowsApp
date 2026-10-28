//
//  Client.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

public protocol Client: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws
}
