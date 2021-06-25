// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Parser",
    products: [
        .executable(name: "tool", targets: ["tool"]),
        .library(
            name: "Parser",
            targets: ["Parser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/niw/GraphQLLanguage", .branch("master")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.3"))
    ],
    targets: [
        .target(
            name: "tool",
            dependencies: [
                "Parser",
                .product(name: "GraphQLLanguage-Auto", package: "GraphQLLanguage"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "Parser",
            dependencies: [.product(name: "GraphQLLanguage-Auto", package: "GraphQLLanguage")]
        ),
        .testTarget(
            name: "ParserTests",
            dependencies: ["Parser"]
        ),
    ]
)
