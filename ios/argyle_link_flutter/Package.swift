// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "argyle_link_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "argyle-link-flutter", targets: ["argyle_link_flutter"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "argyle_link_flutter",
            dependencies: []
        )
    ]
)
