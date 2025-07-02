// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwedishTranscriber",
    platforms: [.macOS(.v14)],
    products: [
        .executable(
            name: "SwedishTranscriber",
            targets: ["SwedishTranscriber"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CWhisper",
            path: "Sources/CWhisper"
        ),
        .executableTarget(
            name: "SwedishTranscriber",
            dependencies: ["CWhisper"],
            path: "Sources/SwedishTranscriber",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
                .linkedFramework("AppKit"),
                .linkedFramework("CoreML"),
                .linkedFramework("Accelerate"),
                .linkedFramework("Metal"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("UniformTypeIdentifiers")
            ]
        ),
    ]
)