// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftStack",
    products: [
        .library(name: "SwiftStack", targets: ["SwiftStack"]),
    ],
                    
    targets: [
        .target(name: "SwiftStack"),
        .testTarget(name: "SwiftStackTests", dependencies: ["SwiftStack"])
    ]
)
