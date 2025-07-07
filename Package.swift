// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "SwiftCodexOpenAPIKernel",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "generator", targets: ["Generator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0")
    ],
    targets: [
        .target(name: "Parser", dependencies: ["Yams"]),
        .target(name: "ModelEmitter", dependencies: ["Parser"]),
        .target(name: "ClientGenerator", dependencies: ["Parser"]),
        .target(name: "ServerGenerator", dependencies: ["Parser"]),
        .executableTarget(
            name: "Generator",
            dependencies: ["Parser", "ModelEmitter", "ClientGenerator", "ServerGenerator"]
        ),
        .testTarget(
            name: "GeneratorTests",
            dependencies: ["Generator"],
            resources: [.process("Fixtures")]
        ),
        .testTarget(name: "ServerTests", dependencies: ["ServerGenerator"]),
        .testTarget(name: "ParserTests", dependencies: ["Parser"]),
        .testTarget(name: "ClientGeneratorTests", dependencies: ["ClientGenerator", "Parser"]),
        .testTarget(
            name: "ModelEmitterTests",
            dependencies: ["ModelEmitter", "Parser"],
            resources: [.process("Fixtures")]
        )
    ]
)
