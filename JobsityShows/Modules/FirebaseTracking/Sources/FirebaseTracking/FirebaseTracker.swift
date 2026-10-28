//
//  FirebaseTracker.swift
//  FirebaseTracking
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
import Tracking

public struct FirebaseTracker: Tracker {

    public init() {}

    public func track(_ event: TrackingEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }

    @MainActor
    public static func start() {
        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else { return }
        FirebaseApp.configure()
        TrackerProvider.current = FirebaseTracker()
    }
}
