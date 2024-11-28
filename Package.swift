// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "CodeGenSupport",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "CodeGenSupport",
            targets: ["CodeGenSupport"]
        ),
        .library(
            name: "CodePreview",
            targets: ["CodePreview"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Splash", from: "0.16.0")
    ],
    targets: [
        .target(
            name: "CodePreview",
            dependencies: [
                .product(name: "Splash", package: "Splash")
            ]
        ),
        .target(
            name: "CodeGenSupport"),
        .testTarget(
            name: "CodeGenSupportTests",
            dependencies: ["CodeGenSupport"]),
    ]
)
