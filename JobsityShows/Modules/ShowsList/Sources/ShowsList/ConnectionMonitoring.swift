//
//  ConnectionMonitoring.swift
//  ShowsList
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

import Reachability

@MainActor
public protocol ConnectionMonitoring: AnyObject {
    var statusDidChange: ((ConnectionStatus) -> Void)? { get set }
    func start()
}

extension ConnectionMonitor: ConnectionMonitoring {}
