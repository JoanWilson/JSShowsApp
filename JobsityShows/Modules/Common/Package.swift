// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]),
    ],
    dependencies: [
        .package(name: "Extensions", path: "../Extensions"),
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                .product(name: "Extensions", package: "Extensions")
            ]),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common"]
        ),
    ]
)
