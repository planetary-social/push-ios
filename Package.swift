// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Push",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Push",
            targets: ["Push"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Logger",
                 url: "https://github.com/planetary-social/logger-ios",
                 from: "0.0.2"),
        .package(name: "Secrets",
                 url: "https://github.com/planetary-social/secrets-ios",
                 from: "0.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Push",
            dependencies: ["Secrets", "Logger"]),
        .testTarget(
            name: "PushTests",
            dependencies: ["Push"]),
    ]
)
