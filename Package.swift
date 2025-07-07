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
    targets: [
        .target(name: "Parser"),
        .target(name: "ModelEmitter"),
        .target(name: "ClientGenerator"),
        .target(name: "ServerGenerator"),
        .executableTarget(
            name: "Generator",
            dependencies: ["Parser", "ModelEmitter", "ClientGenerator", "ServerGenerator"]
        ),
        .testTarget(name: "GeneratorTests", dependencies: ["Generator"]),
        .testTarget(name: "ServerTests", dependencies: ["ServerGenerator"])
    ]
)
