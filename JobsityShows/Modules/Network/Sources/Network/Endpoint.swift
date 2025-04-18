//
//  Endpoint.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import Foundation

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    public func makeRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw URLError(.badURL)
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
