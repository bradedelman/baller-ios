// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Baller",
    products: [
        .library(
            name: "Baller",
            targets: ["Baller"]),
    ],
    targets: [
        .target(
            name: "CallNamedMethod",
            dependencies: []
        ),
        .target(
            name: "Baller",
            dependencies: ["CallNamedMethod"],
            resources: [.copy("baller-assets")]
        )
    ]
)
