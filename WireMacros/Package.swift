// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WireMacros",
    platforms: [.iOS(.v16), .macOS(.v12)],
    products: [
        .library(name: "WireMockGenerator", targets: ["WireMockGenerator"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        .target(name: "WireMockGenerator"),
        .testTarget(
            name: "WireMockGeneratorTests",
            dependencies: ["WireMockGenerator"]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("FullTypedThrows"),
        .enableUpcomingFeature("ExistentialAny")
    ]
}
