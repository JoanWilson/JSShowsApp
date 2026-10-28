// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EpisodeDetail",
    defaultLocalization: "en",
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
        .package(name: "Common", path: "../Common"),
        .package(name: "Tracking", path: "../Tracking"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        .target(
            name: "EpisodeDetail",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Data", package: "Data"),
                .product(name: "Extensions", package: "Extensions"),
                .product(name: "Common", package: "Common"),
                .product(name: "Tracking", package: "Tracking"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "EpisodeDetailTests",
            dependencies: [
                "EpisodeDetail",
                .product(name: "Domain", package: "Domain"),
                .product(name: "Tracking", package: "Tracking")
            ]
        ),
    ]
)
