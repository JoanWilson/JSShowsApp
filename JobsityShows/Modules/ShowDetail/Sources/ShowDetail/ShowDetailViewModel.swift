//
//  ShowDetailViewModel.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import Foundation
import Domain
import Data

@MainActor
public final class ShowDetailViewModel: ObservableObject {

    @Published private(set) var show: Show?
    @Published private(set) var seasons: [Season] = []
    @Published private(set) var episodes: [Episode] = []
    @Published private(set) var selectedSeason: Season?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let showId: Int
    private let useCase: ShowsUseCaseProtocol

    public init(showId: Int, useCase: ShowsUseCaseProtocol = ShowsRepository()) {
        self.showId = showId
        self.useCase = useCase
    }

    public init(show: Show, useCase: ShowsUseCaseProtocol = ShowsRepository()) {
        self.show = show
        self.showId = show.id
        self.useCase = useCase
    }

    public func loadData() async {
        await fetchShow()
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
            self.error = error
            print(error.localizedDescription)
        }

        isLoading = false
    }

    public func fetchSeasons() async -> Season? {
        isLoading = true
        error = nil

        do {
            let fetchedSeasons: [Season] = try await useCase.fetchSeasons(showId: showId)
            seasons = fetchedSeasons
            selectedSeason = fetchedSeasons.first
            return fetchedSeasons.first
        } catch {
            self.error = error
            print(error.localizedDescription)
        }

        isLoading = false
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
            self.error = error
            print(error.localizedDescription)
        }

        isLoading = false
    }

    public func selectSeason(season: Season) async {
        selectedSeason = season
        await fetchEpisodes()
    }

    func getFormattedSummary() -> String {
        return show?.summary?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? ""
    }

    func getGenresString() -> String {
        return show?.genres.joined(separator: ", ") ?? ""
    }

}
