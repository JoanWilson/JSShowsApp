//
//  NetworkError.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case underlying(Error)
    case noData

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .statusCode(let code):
            return "Unexpected HTTP status code: \(code)."
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .underlying(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "No data received."
        }
    }
}
