//
//  ConnectionMonitorTests.swift
//  ReachabilityTests
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

import XCTest
import Reachability

@MainActor
final class ConnectionMonitorTests: XCTestCase {

    func test_init_statusIsUnknown() {
        let sut = ConnectionMonitor()

        XCTAssertEqual(sut.status, .unknown)
        XCTAssertFalse(sut.isConnected)
    }

    func test_update_newStatus_notifiesChange() {
        let sut = ConnectionMonitor()
        var received: [ConnectionStatus] = []
        sut.statusDidChange = { received.append($0) }

        sut.update(.connected)

        XCTAssertEqual(received, [.connected])
        XCTAssertTrue(sut.isConnected)
    }

    func test_update_sameStatus_doesNotNotifyAgain() {
        let sut = ConnectionMonitor()
        var received: [ConnectionStatus] = []
        sut.statusDidChange = { received.append($0) }

        sut.update(.disconnected)
        sut.update(.disconnected)

        XCTAssertEqual(received, [.disconnected])
    }

    func test_start_reportsCurrentPath() {
        let sut = ConnectionMonitor()
        let expectation = expectation(description: "path update")
        sut.statusDidChange = { _ in expectation.fulfill() }

        sut.start()

        wait(for: [expectation], timeout: 2)
        XCTAssertNotEqual(sut.status, .unknown)
        sut.stop()
    }

    func test_stop_withoutStart_isSafe() {
        let sut = ConnectionMonitor()

        sut.stop()
        sut.stop()

        XCTAssertEqual(sut.status, .unknown)
    }
}
