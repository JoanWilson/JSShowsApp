// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EpisodeDetail",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "EpisodeDetail",
            targets: ["EpisodeDetail"]),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Data", path: "../Data"),
        .package(name: "Extensions", path: "../Extensions"),
        .package(name: "Common", path: "../Common")
    ],
    targets: [
        .target(
            name: "EpisodeDetail",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Data", package: "Data"),
                .product(name: "Extensions", package: "Extensions"),
                .product(name: "Common", package: "Common")
            ]),
        .testTarget(
            name: "EpisodeDetailTests",
            dependencies: ["EpisodeDetail"]
        ),
    ]
)
