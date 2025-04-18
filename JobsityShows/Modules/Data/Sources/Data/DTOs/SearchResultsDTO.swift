//
//  SearchResultsDTO.swift
//  Data
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation
import Domain

public struct SearchResultsDTO: Decodable {
    public let score: Double
    public let show: ShowDTO
    
    public init(score: Double, show: ShowDTO) {
        self.score = score
        self.show = show
    }
    
    public func toDomain() -> SearchResult {
        SearchResult(
            score: score,
            show: show.toDomain()
        )
    }
}
