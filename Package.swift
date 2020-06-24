// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "pure-swift-json",
    products: [
        .library(
            name: "PureSwiftJSONCoding",
            targets: ["PureSwiftJSONCoding"]
        ),
        .library(
            name: "PureSwiftJSONParsing",
            targets: ["PureSwiftJSONParsing"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PureSwiftJSONCoding",
            dependencies: ["PureSwiftJSONParsing"]
        ),
        .target(
            name: "PureSwiftJSONParsing",
            dependencies: []
        ),
        .testTarget(
            name: "JSONCodingTests",
            dependencies: ["PureSwiftJSONCoding"]
        ),
        .testTarget(
            name: "JSONParsingTests",
            dependencies: ["PureSwiftJSONParsing"]
        ),
        .testTarget(
            name: "LearningTests",
            dependencies: ["PureSwiftJSONParsing"]
        ),
    ]
)
