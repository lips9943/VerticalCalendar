// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VerticalCalendar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "VerticalCalendar",
            targets: ["VerticalCalendar"]),
    ],
    dependencies: [
        // No external dependencies for now
    ],
    targets: [
        .target(
            name: "VerticalCalendar",
            dependencies: [],
            path: "Sources/VerticalCalendar"
        ),
    ]
)
