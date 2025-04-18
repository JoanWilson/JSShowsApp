//
//  ShowDTO.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation
import Domain

public struct ShowDTO: Decodable {
    public let id: Int
    public let name: String
    public let genres: [String]
    public let schedule: ScheduleDTO
    public let image: ImageDTO?
    public let summary: String?

    public init(id: Int, name: String, genres: [String], schedule: ScheduleDTO, image: ImageDTO?, summary: String?) {
        self.id = id
        self.name = name
        self.genres = genres
        self.schedule = schedule
        self.image = image
        self.summary = summary
    }

    public func toDomain() -> Show {
        Show(id: id,
             name: name,
             genres: genres,
             schedule: Show.Schedule(time: schedule.time,
                                     days: schedule.days),
             image: image.map {
            Show.Image(medium: $0.medium, original: $0.original)
        },
             summary: summary?.removingHTMLTags()
        )
    }
}

extension ShowDTO {
    public struct ScheduleDTO: Decodable {
        public let time: String
        public let days: [String]

        public init(time: String, days: [String]) {
            self.time = time
            self.days = days
        }
    }
}

extension ShowDTO {
    public struct ImageDTO: Decodable {
        public let medium: String
        public let original: String

        public init(medium: String, original: String) {
            self.medium = medium
            self.original = original
        }

        public func toDomain() -> Show.Image {
            Show.Image(medium: medium, original: original)
        }
    }
}
