//
//  ShowDetailHostingController.swift
//  ShowDetail
//
//  Created by Joan Wilson Oliveira on 18/04/25.
//

import SwiftUI

public final class ShowDetailHostingController: UIHostingController<ShowDetailView> {
    public init(viewModel: ShowDetailViewModel) {
        let view = ShowDetailView(viewModel: viewModel)
        super.init(rootView: view)
    }

    @available(*, unavailable)
    @MainActor
    @preconcurrency
    required dynamic init?(coder aDecoder: NSCoder) { nil }
}
