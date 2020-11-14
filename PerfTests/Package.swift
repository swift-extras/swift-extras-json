// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "swift-extras-json-performance",
    products: [
        .executable(name: "CodingPerfTests", targets: ["CodingPerfTests"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.13.0"),
        .package(url: "https://github.com/autimatisering/IkigaJSON.git", from: "2.0.0"),
        .package(path: ".."),
    ],
    targets: [
        .target(
            name: "CodingPerfTests",
            dependencies: [
                .product(name: "ExtrasJSON", package: "swift-extras-json"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "IkigaJSON", package: "IkigaJSON"),
            ]
        ),
    ]
)

#if os(macOS)
package.dependencies.append(.package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"))
package.targets.last?.dependencies.append("SwiftyJSON")
#endif
