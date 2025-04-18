//
//  ErrorView.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () async -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Failed to load show details")
                .font(.headline)
            
            Button("Try Again") {
                Task {
                    await retryAction()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
