//
//  ExpandableSummaryView.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import SwiftUI
import Extensions

public struct ExpandableSummaryView: View {
    let text: String
    let previewLineLimit: Int
    
    @State private var isExpanded = false
    @State private var isTruncated: Bool = false
    @State private var showFullScreen = false
    
    public init(text: String, previewLineLimit: Int = 5) {
        self.text = text
        self.previewLineLimit = previewLineLimit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.footnote)
                .foregroundColor(.secondary)

            VStack(alignment: .leading) {
                Text(text)
                    .lineLimit(isExpanded ? nil : previewLineLimit)
                    .animation(.easeInOut, value: isExpanded)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            self.determineTruncation(geometry)
                        }
                    })

                if isTruncated {
                    Button(action: { showFullScreen = true }) {
                        Text(isExpanded ? "Show Less" : "Show More")
                            .padding(.top, 3)
                            .font(.footnote)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .sheet(isPresented: $showFullScreen) {
            FullSummaryView(text: text)
                .presentationDetents([.fraction(0.8), .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func determineTruncation(_ geometry: GeometryProxy) {
        let total = self.text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )

        if total.size.height > geometry.size.height {
            self.isTruncated = true
        }
    }
}

public struct FullSummaryView: View {
    @Environment(\.dismiss) var dismiss

    let text: String

    public var body: some View {
        NavigationView {
            ScrollView {
                Text(text)
                    .padding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
