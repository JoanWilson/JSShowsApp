//
//  TrackerSpy.swift
//  EpisodeDetailTests
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

import Tracking

final class TrackerSpy: Tracker, @unchecked Sendable {

    private(set) var events: [TrackingEvent] = []

    func track(_ event: TrackingEvent) {
        events.append(event)
    }
}
