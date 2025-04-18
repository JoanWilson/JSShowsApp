//
//  EpisodeView.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import Domain
import SwiftUI
import Kingfisher

struct EpisodeView: View {
    let episode: Episode

    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = episode.image?.medium {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .placeholder {
                        Color.gray.opacity(0.3)
                    }
                    .scaleFactor(UIScreen.main.scale)
                    .cacheOriginalImage()
                    .fade(duration: 0.3)
                    .scaledToFill()
                    .frame(width: 160, height: 110)
                    .cornerRadius(8)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(episode.name)
                    .font(.headline)
                    .lineLimit(1)

                Text("S\(episode.season)E\(episode.number)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let summary = episode.summary {
                    Text(summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let runtime = episode.runtime {
                    Text("\(runtime) min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.trailing, 10)

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
