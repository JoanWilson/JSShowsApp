// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseTracking",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "FirebaseTracking",
            targets: ["FirebaseTracking"]),
    ],
    dependencies: [
        .package(name: "Tracking", path: "../Tracking"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMinor(from: "13.0.1"))
    ],
    targets: [
        .target(
            name: "FirebaseTracking",
            dependencies: [
                .product(name: "Tracking", package: "Tracking"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ]),
    ]
)
