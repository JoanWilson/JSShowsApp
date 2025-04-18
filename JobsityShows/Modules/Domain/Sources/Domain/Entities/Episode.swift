//
//  Episode.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import Foundation

public struct Episode: Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let season: Int
    public let number: Int
    public let summary: String?
    public let image: Show.Image?
    public let runtime: Int?

    public init(id: Int, name: String, season: Int, number: Int, summary: String?, image: Show.Image?, runtime: Int?) {
        self.id = id
        self.name = name
        self.season = season
        self.number = number
        self.summary = summary
        self.image = image
        self.runtime = runtime
    }
}
