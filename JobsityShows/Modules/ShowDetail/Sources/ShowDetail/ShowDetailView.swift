//
//  ShowDetailView.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import SwiftUI
import Kingfisher
import Domain

public struct ShowDetailView: View {
    @StateObject private var viewModel: ShowDetailViewModel

    public init(viewModel: ShowDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if viewModel.isLoading && viewModel.show == nil {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task { await viewModel.loadData() }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else if let show = viewModel.show {
                    showContent(show: show)
                } else {
                    Text("No show data available")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle(viewModel.show?.name ?? "Show Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .task { await viewModel.loadData() }
    }

    @ViewBuilder
    private func showContent(show: Show) -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                showCover(show)
                showSummary(show)
                showGenres(show)
                showSchedule(show)
                seasonSelector
                episodesList
            }
        }
        .background(Color(.systemBackground))
    }

    @ViewBuilder
    private func showCover(_ show: Show) -> some View {
        if let imageUrl = show.image?.original {
            KFImage(URL(string: imageUrl))
                .resizable()
                .placeholder {
                    Color.gray.opacity(0.3)
                }
                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width, height: 350)))
                .scaleFactor(UIScreen.main.scale)
                .cacheOriginalImage()
                .fade(duration: 0.3)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 350)
                .clipped()
        }
    }

    @ViewBuilder
    private func showSummary(_ show: Show) -> some View {
        if let summary = show.summary {
            ExpandableSummaryView(
                text: summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression),
                previewLineLimit: 5
            )
        }
    }

    @ViewBuilder
    private func showGenres(_ show: Show) -> some View {
        if !show.genres.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(show.genres, id: \.self) { genre in
                        Text(genre)
                            .font(.footnote)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.accentColor.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    @ViewBuilder
    private func showSchedule(_ show: Show) -> some View {
        HStack {
            ScheduleView(schedule: show.schedule)
            Spacer()
        }
    }

    @ViewBuilder
    private var seasonSelector: some View {
        VStack {
            Divider()

            HStack {
                SeasonDropdown(
                    selectedSeason: Binding(
                        get: { viewModel.selectedSeason },
                        set: { newSeason in
                            if let season = newSeason {
                                Task {
                                    await viewModel.selectSeason(season: season)
                                }
                            }
                        }
                    ),
                    seasons: viewModel.seasons
                )
                Spacer()
            }
            .padding(.leading, 16)

            Divider()
        }
    }

    @ViewBuilder
    private var episodesList: some View {
        if viewModel.isLoading && !viewModel.episodes.isEmpty {
            ProgressView("Loading episodes...")
                .padding()
                .frame(maxWidth: .infinity)
        } else if viewModel.episodes.isEmpty {
            Text("No episodes available for this season")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity)
        } else {
            ForEach(viewModel.episodes) { episode in
                EpisodeView(episode: episode)
                    .padding(.vertical, 4)
            }
        }
    }
}



#Preview {
    ShowDetailView(viewModel: ShowDetailViewModel(showId: 1))
}
