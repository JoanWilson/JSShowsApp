//
//  ConnectionMonitorStub.swift
//  ShowsListTests
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

import Reachability
import ShowsList

final class ConnectionMonitorStub: ConnectionMonitoring {

    var statusDidChange: ((ConnectionStatus) -> Void)?
    private(set) var startCount: Int = 0

    func start() {
        startCount += 1
    }

    func send(_ status: ConnectionStatus) {
        statusDidChange?(status)
    }
}
