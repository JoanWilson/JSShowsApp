// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    targets: [
        .target(
            name: "Network"),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]
        ),
    ]
)
