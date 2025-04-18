//
//  SeasonDTO.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Domain

struct SeasonDTO: Decodable {
    let id: Int
    let number: Int
    let episodeOrder: Int?
    let image: ShowDTO.ImageDTO?

    func toDomain() -> Season {
        Season(
            id: id,
            number: number,
            episodeCount: episodeOrder ?? 0,
            image: image?.toDomain()
        )
    }
}
