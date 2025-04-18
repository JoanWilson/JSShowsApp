//
//  ViewCoding.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

@MainActor
public protocol ViewCoding {
    func setupConfiguration()
    func setupHierarchy()
    func setupConstraints()
}

@MainActor
extension ViewCoding {
    public func setupViews() {
        setupConfiguration()
        setupHierarchy()
        setupConstraints()
    }

    public func setupConfiguration() {}
}
