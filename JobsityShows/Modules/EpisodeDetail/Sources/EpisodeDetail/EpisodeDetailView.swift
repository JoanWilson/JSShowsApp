//
//  EpisodeDetailView.swift
//  EpisodeDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import SwiftUI
import Kingfisher
import Domain
import Common
import Extensions

public struct EpisodeDetailView: View {
    @StateObject private var viewModel: EpisodeDetailViewModel

    public init(viewModel: EpisodeDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.isLoading && viewModel.episode == nil {
                loadingView
            } else if let error = viewModel.error {
                errorView(error: error)
            } else if let episode = viewModel.episode {
                episodeContentView(episode: episode)
            } else {
                emptyStateView
            }
        }
        .navigationTitle("Episode Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .task { await viewModel.loadData() }
    }

    private var loadingView: some View {
        ProgressView("Loading...")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private func errorView(error: Error) -> some View {
        ErrorView(error: error) {
            Task { await viewModel.loadData() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var emptyStateView: some View {
        Text("No episode data available")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func episodeContentView(episode: Episode) -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                episodeHeaderImage(episode)
                episodeInfoSection(episode)
                episodeSummarySection(episode)
            }
        }
        .background(Color(.systemBackground))
    }

    @ViewBuilder
    private func episodeHeaderImage(_ episode: Episode) -> some View {
        if let imageUrl = episode.image?.original {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaleFactor(UIScreen.main.scale)
                .cacheOriginalImage()
                .fade(duration: 0.3)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 350)
                .clipped()
        }
    }

    @ViewBuilder
    private func episodeInfoSection(_ episode: Episode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Season \(episode.season) • Episode \(episode.number)")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(episode.name)
                .font(.title)
                .fontWeight(.bold)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func episodeSummarySection(_ episode: Episode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let summary: String = episode.summary, !summary.isEmpty {
                Text("Summary")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(summary.removingHTMLTags())
            } else {
                Text("No summary available for this episode.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
    }
}
