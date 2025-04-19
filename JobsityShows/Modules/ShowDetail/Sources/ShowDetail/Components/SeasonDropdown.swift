//
//  SeasonDropdown.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import Domain
import SwiftUI

struct SeasonDropdown: View {
    @Binding var selectedSeason: Season?
    let seasons: [Season]

    var body: some View {
        Menu {
            ForEach(seasons) { season in
                Button(action: {
                    selectedSeason = season
                }) {
                    if selectedSeason?.id == season.id {
                        Label("Season \(season.number)", systemImage: "checkmark")
                    } else {
                        Text("Season \(season.number)")
                    }
                }
            }
        } label: {
            HStack {
                Text("Season \(selectedSeason?.number ?? 1)")
                    .fontWeight(.medium)
                Image(systemName: "chevron.down")
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .foregroundColor(.primary)
        }
        .disabled(seasons.isEmpty)
    }
}
