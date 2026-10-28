// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reachability",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Reachability",
            targets: ["Reachability"]),
    ],
    targets: [
        .target(
            name: "Reachability",
            linkerSettings: [.linkedFramework("Network")]),
        .testTarget(
            name: "ReachabilityTests",
            dependencies: ["Reachability"]
        ),
    ]
)
