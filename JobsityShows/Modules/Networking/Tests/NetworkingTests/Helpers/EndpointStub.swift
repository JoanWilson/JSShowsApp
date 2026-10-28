//
//  EndpointStub.swift
//  NetworkingTests
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

import Foundation
@testable import Networking

struct EndpointStub: Endpoint {
    var baseURL: String = "https://api.example.com"
    var path: String = "/items"
    var method: HTTPMethod = .GET
    var queryItems: [URLQueryItem]? = nil
}
