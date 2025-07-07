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
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.21.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.63.0")
    ],
    targets: [
        .target(name: "Parser", dependencies: ["Yams"]),
        .target(name: "ModelEmitter", dependencies: ["Parser"]),
        .target(name: "ClientGenerator", dependencies: ["Parser"]),
        .target(name: "ServerGenerator", dependencies: ["Parser"]),
        .target(
            name: "IntegrationRuntime",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio")
            ]
        ),
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
        ),
        .testTarget(
            name: "IntegrationTests",
            dependencies: ["IntegrationRuntime"],
            resources: []
        )
    ]
)
