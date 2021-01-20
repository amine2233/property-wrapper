// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "property-wrapper",
    platforms: [
        .iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PropertyWrapper",
            targets: ["PropertyWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/amine2233/swift-extension", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PropertyWrapper",
            dependencies: [
                .product(name: "FoundationExtension", package: "swift-extension")
            ]),
        .testTarget(
            name: "PropertyWrapperTests",
            dependencies: ["PropertyWrapper"]),
    ]
)
