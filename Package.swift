// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "swift-extras-json",
    products: [
        .library(name: "ExtrasJSON", targets: ["ExtrasJSON"]),
    ],
    targets: [
        .target(name: "ExtrasJSON"),
        .testTarget(name: "ExtrasJSONTests", dependencies: [
            .byName(name: "ExtrasJSON"),
        ]),
        .testTarget(name: "LearningTests", dependencies: [
            .byName(name: "ExtrasJSON"),
        ]),
    ]
)
