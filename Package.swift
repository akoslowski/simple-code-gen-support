// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CodeGenSupport",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "CodeGenSupport",
            targets: ["CodeGenSupport"]),
    ],
    targets: [
        .target(
            name: "CodeGenSupport"),
        .testTarget(
            name: "CodeGenSupportTests",
            dependencies: ["CodeGenSupport"]),
    ]
)
