// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
  name: "pure-swift-json",
  products: [
    .library(
      name: "PureSwiftJSONCoding",
      targets: ["PureSwiftJSONCoding"]),
    .library(
      name: "PureSwiftJSONParsing",
      targets: ["PureSwiftJSONParsing"]),
  ],
  dependencies: [
    // these are only used for testing
    .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "0.0.1")),
    .package(url: "https://github.com/apple/swift-nio", .upToNextMajor(from: "2.13.0"))
  ],
  targets: [
    .target(
      name: "JSONTestSuiteCLI",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "NIO", package: "swift-nio"),
      ]
    ),
    .target(
      name: "PureSwiftJSONCoding",
      dependencies: ["PureSwiftJSONParsing"]),
    .target(
      name: "PureSwiftJSONParsing",
      dependencies: []),
    .testTarget(
      name: "JSONCodingTests",
      dependencies: ["PureSwiftJSONCoding"]),
    .testTarget(
      name: "JSONParsingTests",
      dependencies: ["PureSwiftJSONParsing"]),
    .testTarget(
      name: "LearningTests",
      dependencies: ["PureSwiftJSONParsing"]),
  ]
)

