//
//  Season.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import Foundation

public struct Season: Identifiable, Equatable, Sendable {
    public let id: Int
    public let number: Int
    public let episodeCount: Int
    public let image: Show.Image?

    public init(id: Int, number: Int, episodeCount: Int, image: Show.Image?) {
        self.id = id
        self.number = number
        self.episodeCount = episodeCount
        self.image = image
    }
}
