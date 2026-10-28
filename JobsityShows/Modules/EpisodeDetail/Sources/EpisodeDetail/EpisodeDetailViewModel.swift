//
//  EpisodeDetailViewModel.swift
//  EpisodeDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import Foundation
import Domain
import Data
import Tracking

@MainActor
public final class EpisodeDetailViewModel: ObservableObject {

    @Published private(set) var episode: Episode?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let episodeId: Int
    private let useCase: ShowsUseCaseProtocol
    private let tracker: Tracker

    public init(episodeId: Int, useCase: ShowsUseCaseProtocol = ShowsRepository(), tracker: Tracker = TrackerProvider.current) {
        self.episodeId = episodeId
        self.useCase = useCase
        self.tracker = tracker
    }

    public init(episode: Episode, useCase: ShowsUseCaseProtocol = ShowsRepository(), tracker: Tracker = TrackerProvider.current) {
        self.episode = episode
        self.episodeId = episode.id
        self.useCase = useCase
        self.tracker = tracker
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
            tracker.track(.loadFailed(.episodeDetail))
        }

        isLoading = false
    }

    public func retry() async {
        tracker.track(.retry(.episodeDetail))
        await loadData()
    }

    public func trackScreenView() {
        tracker.track(.screenView(.episodeDetail, itemId: episodeId))
    }

}
