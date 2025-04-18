//
//  HTTPClient.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import Foundation

public final class HTTPClient: Client {
    private let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try endpoint.makeRequest()

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }

            guard !data.isEmpty else {
                throw NetworkError.noData
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }

        } catch {
            throw NetworkError.underlying(error)
        }
    }

    public func request(_ endpoint: Endpoint) async throws {
        let request = try endpoint.makeRequest()

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }

        } catch {
            throw NetworkError.underlying(error)
        }
    }
}
