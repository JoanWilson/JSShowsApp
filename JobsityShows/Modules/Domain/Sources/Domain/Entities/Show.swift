//
//  Show.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import Foundation

public struct Show: Identifiable, Equatable, Codable, Sendable {
    public let id: Int
    public let name: String
    public let genres: [String]
    public let schedule: Schedule
    public let image: Image?
    public let summary: String?

    public init(id: Int, name: String, genres: [String], schedule: Schedule, image: Image?, summary: String?) {
        self.id = id
        self.name = name
        self.genres = genres
        self.schedule = schedule
        self.image = image
        self.summary = summary
    }
}

extension Show {
    public struct Schedule: Equatable, Codable, Sendable {
        public let time: String
        public let days: [String]

        public init(time: String, days: [String]) {
            self.time = time
            self.days = days
        }
    }
}

extension Show {
    public struct Image: Equatable, Codable, Sendable {
        public let medium: String
        public let original: String

        public init(medium: String, original: String) {
            self.medium = medium
            self.original = original
        }
    }
}
