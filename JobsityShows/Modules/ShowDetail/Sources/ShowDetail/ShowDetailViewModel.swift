//
//  ShowDetailViewModel.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import Foundation
import Domain
import Data
import Tracking

enum ShowDetailError: Error {
    case showError
    case seasonError
    case episodesError
}

@MainActor
public final class ShowDetailViewModel: ObservableObject {

    @Published private(set) var show: Show?
    @Published private(set) var seasons: [Season] = []
    @Published private(set) var episodes: [Episode] = []
    @Published private(set) var selectedSeason: Season?
    @Published private(set) var isLoading = false
    @Published private(set) var error: ShowDetailError?

    private let showId: Int
    private let useCase: ShowsUseCaseProtocol
    private let tracker: Tracker

    public init(showId: Int, useCase: ShowsUseCaseProtocol = ShowsRepository(), tracker: Tracker = TrackerProvider.current) {
        self.showId = showId
        self.useCase = useCase
        self.tracker = tracker
    }

    public init(show: Show, useCase: ShowsUseCaseProtocol = ShowsRepository(), tracker: Tracker = TrackerProvider.current) {
        self.show = show
        self.showId = show.id
        self.useCase = useCase
        self.tracker = tracker
    }

    public func loadData() async {
        await fetchShow()
        guard show != nil else { return }
        let firstSeason: Season? = await fetchSeasons()
        await fetchEpisodes(for: firstSeason)
    }

    public func fetchShow() async {
        isLoading = true
        error = nil

        do {
            let fetchedShow: Show = try await useCase.fetchShowById(id: showId)
            show = fetchedShow
        } catch {
            self.error = .showError
            print(error.localizedDescription)
            if show == nil {
                tracker.track(.loadFailed(.showDetail))
            }
        }

        isLoading = false
    }

    public func fetchSeasons() async -> Season? {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            let fetchedSeasons: [Season] = try await useCase.fetchSeasons(showId: showId)
            seasons = fetchedSeasons
            selectedSeason = fetchedSeasons.first
            return fetchedSeasons.first
        } catch {
            self.error = .seasonError
            print(error.localizedDescription)
        }

        return nil
    }

    public func fetchEpisodes(for season: Season? = nil) async {
        let seasonToUse = season ?? selectedSeason
        guard let selectedSeason = seasonToUse else { return }

        isLoading = true
        error = nil

        do {
            let fetchedEpisodes: [Episode] = try await useCase.fetchEpisodes(seasonId: selectedSeason.id)
            episodes = fetchedEpisodes
        } catch {
            self.error = .episodesError
            print(error.localizedDescription)
        }

        isLoading = false
    }

    public func selectSeason(season: Season) async {
        selectedSeason = season
        tracker.track(.selectSeason(showId: showId, season: season.number))
        await fetchEpisodes()
    }

    public func retry() async {
        tracker.track(.retry(.showDetail))
        await loadData()
    }

    public func trackScreenView() {
        tracker.track(.screenView(.showDetail, itemId: showId))
    }

    func getFormattedSummary() -> String {
        return show?.summary?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? ""
    }

    func getGenresString() -> String {
        return show?.genres.joined(separator: ", ") ?? ""
    }

}
