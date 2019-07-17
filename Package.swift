// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "VaporErrorKit",
    products: [
        .library(name: "VaporErrorKit", targets: ["VaporErrorKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/Einstore/NIOErrorKit.git", from: "0.0.1"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.1.5")
    ],
    targets: [
        .target(
            name: "VaporErrorKit",
            dependencies: [
                "NIOErrorKit",
                "Vapor"
            ]
        )
    ]
)


