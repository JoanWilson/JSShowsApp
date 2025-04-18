//
//  SearchResult.swift
//  Domain
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation

public struct SearchResult: Sendable, Codable {
    public let score: Double
    public let show: Show
    
    public init(score: Double, show: Show) {
        self.score = score
        self.show = show
    }
}
