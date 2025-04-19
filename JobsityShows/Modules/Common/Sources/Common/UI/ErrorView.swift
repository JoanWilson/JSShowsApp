//
//  ErrorView.swift
//  Common
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import SwiftUI

public struct ErrorView: View {

    private let error: Error
    private let retryAction: () async -> Void

    public init(error: Error, retryAction: @escaping () async -> Void) {
        self.error = error
        self.retryAction = retryAction
    }

    public var body: some View {
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
