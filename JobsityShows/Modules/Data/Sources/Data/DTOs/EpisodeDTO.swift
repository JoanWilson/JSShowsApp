//
//  EpisodeDTO.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation
import Domain
import Extensions

public struct EpisodeDTO: Decodable {
    public let id: Int
    public let name: String
    public let season: Int
    public let number: Int
    public let summary: String?
    public let image: ShowDTO.ImageDTO?
    public let runtime: Int?

    public init(id: Int, name: String, season: Int, number: Int, summary: String?, image: ShowDTO.ImageDTO?, runtime: Int?) {
        self.id = id
        self.name = name
        self.season = season
        self.number = number
        self.summary = summary
        self.image = image
        self.runtime = runtime
    }

    public func toDomain() -> Episode {
        Episode(
            id: id,
            name: name,
            season: season,
            number: number,
            summary: summary?.removingHTMLTags(),
            image: image?.toDomain(),
            runtime: runtime
        )
    }
}
