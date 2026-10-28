//
//  Tracker.swift
//  Tracking
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

public protocol Tracker: Sendable {
    func track(_ event: TrackingEvent)
}

public struct NoopTracker: Tracker {
    public init() {}

    public func track(_ event: TrackingEvent) {}
}

@MainActor
public enum TrackerProvider {
    public static var current: Tracker = NoopTracker()
}
