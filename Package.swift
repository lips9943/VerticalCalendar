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
        .package(
            url: "https://github.com/HeroTransitions/Hero.git",
            .upToNextMajor(from: "1.6.3")
        )
    ],
    targets: [
        .target(
            name: "VerticalCalendar",
            dependencies: [
                .product(name: "Hero", package: "Hero")
            ],
            path: "Sources/VerticalCalendar"
        ),
    ]
)
