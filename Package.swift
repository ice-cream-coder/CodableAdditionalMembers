// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AdditionalMembers",
    products: [
        .library(
            name: "AdditionalMembers",
            targets: ["AdditionalMembers"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AdditionalMembers",
            dependencies: []),
        .testTarget(
            name: "AdditionalMembersTests",
            dependencies: ["AdditionalMembers"]),
    ]
)
