//
//  EpisodeDetailViewModel.swift
//  EpisodeDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import Foundation
import Domain
import Data

@MainActor
public final class EpisodeDetailViewModel: ObservableObject {

    @Published private(set) var episode: Episode?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let episodeId: Int
    private let useCase: ShowsUseCaseProtocol

    public init(episodeId: Int, useCase: ShowsUseCaseProtocol = ShowsRepository()) {
        self.episodeId = episodeId
        self.useCase = useCase
    }

    public init(episode: Episode, useCase: ShowsUseCaseProtocol = ShowsRepository()) {
        self.episode = episode
        self.episodeId = episode.id
        self.useCase = useCase
    }

    public func loadData() async {
        isLoading = true
        error = nil

        do {
            let fetchedEpisode: Episode = try await useCase.fetchEpisodeById(episodeId: episodeId)
            episode = fetchedEpisode
        } catch {
            self.error = error
            print(error.localizedDescription)
        }

        isLoading = false
    }

}
