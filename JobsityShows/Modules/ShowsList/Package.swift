// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShowsList",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "ShowsList",
            targets: ["ShowsList"]),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Data", path: "../Data"),
        .package(name: "Extensions", path: "../Extensions"),
        .package(name: "Common", path: "../Common"),
        .package(name: "ShowDetail", path: "../ShowDetail")
    ],
    targets: [
        .target(
            name: "ShowsList",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Data", package: "Data"),
                .product(name: "Extensions", package: "Extensions"),
                .product(name: "Common", package: "Common"),
                .product(name: "ShowDetail", package: "ShowDetail")
            ]),
        .testTarget(
            name: "ShowsListTests",
            dependencies: ["ShowsList"]
        ),
    ]
)
