// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Projector",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Projector", targets: ["Projector"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Projector",
            dependencies: [],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
            ]
        ),
        .testTarget(
            name: "ProjectorTests",
            dependencies: ["Projector"]
        )
    ]
)
