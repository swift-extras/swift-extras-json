// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "pure-swift-json",
    products: [
        .library(name: "PureSwiftJSON", targets: ["PureSwiftJSON"]),
    ],
    targets: [
        .target(name: "PureSwiftJSON"),
        .testTarget(name: "PureSwiftJSONTests", dependencies: [
            .byName(name: "PureSwiftJSON"),
        ]),
        .testTarget(name: "LearningTests", dependencies: [
            .byName(name: "PureSwiftJSON"),
        ]),
    ]
)
