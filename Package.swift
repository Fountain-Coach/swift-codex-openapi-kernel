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
        .target(name: "ServiceShared", path: "Generated/Server/Shared"),
        // Generated service modules used for integration testing
        .target(
            name: "BaselineAwarenessService",
            dependencies: ["ServiceShared"],
            path: "Generated/Server",
            sources: [
                "baseline-awareness/HTTPKernel.swift",
                "baseline-awareness/Router.swift",
                "baseline-awareness/Handlers.swift",
                "baseline-awareness/Models.swift",
                "baseline-awareness/HTTPRequest.swift",
                "baseline-awareness/HTTPResponse.swift",
                "baseline-awareness/BaselineStore.swift"
            ]
        ),
        .target(name: "BaselineAwarenessClient", path: "Generated/Client/baseline-awareness"),
        .target(
            name: "BootstrapService",
            dependencies: ["ServiceShared"],
            path: "Generated/Server",
            sources: [
                "bootstrap/HTTPKernel.swift",
                "bootstrap/Router.swift",
                "bootstrap/Handlers.swift",
                "bootstrap/Models.swift",
                "bootstrap/HTTPRequest.swift",
                "bootstrap/HTTPResponse.swift"
            ]
        ),
        .target(name: "BootstrapClient", path: "Generated/Client/bootstrap"),
        .target(
            name: "PersistService",
            dependencies: ["ServiceShared"],
            path: "Generated/Server",
            sources: [
                "persist/HTTPKernel.swift",
                "persist/Router.swift",
                "persist/Handlers.swift",
                "persist/Models.swift",
                "persist/HTTPRequest.swift",
                "persist/HTTPResponse.swift"
            ]
        ),
        .target(name: "PersistClient", path: "Generated/Client/persist"),
        .target(
            name: "FunctionCallerService",
            dependencies: ["ServiceShared"],
            path: "Generated/Server",
            sources: [
                "function-caller/HTTPKernel.swift",
                "function-caller/Router.swift",
                "function-caller/Handlers.swift",
                "function-caller/Models.swift",
                "function-caller/Dispatcher.swift",
                "function-caller/HTTPRequest.swift",
                "function-caller/HTTPResponse.swift"
            ]
        ),
        .target(name: "FunctionCallerClient", path: "Generated/Client/function-caller"),
        .target(
            name: "PlannerService",
            dependencies: ["ServiceShared"],
            path: "Generated/Server",
            sources: [
                "planner/HTTPKernel.swift",
                "planner/Router.swift",
                "planner/Handlers.swift",
                "planner/Models.swift",
                "planner/LLMGatewayClient.swift",
                "planner/HTTPRequest.swift",
                "planner/HTTPResponse.swift"
            ]
        ),
        .target(name: "PlannerClient", path: "Generated/Client/planner"),
        .target(
            name: "ToolsFactoryService",
            dependencies: ["ServiceShared"],
            path: "Generated/Server",
            sources: [
                "tools-factory/HTTPKernel.swift",
                "tools-factory/Router.swift",
                "tools-factory/Handlers.swift",
                "tools-factory/Models.swift",
                "tools-factory/HTTPRequest.swift",
                "tools-factory/HTTPResponse.swift"
            ]
        ),
        .target(name: "ToolsFactoryClient", path: "Generated/Client/tools-factory"),
        .target(
            name: "LLMGatewayService",
            dependencies: ["ServiceShared"],
            path: "Generated/Server",
            sources: [
                "llm-gateway/HTTPKernel.swift",
                "llm-gateway/Router.swift",
                "llm-gateway/Handlers.swift",
                "llm-gateway/Models.swift",
                "llm-gateway/HTTPRequest.swift",
                "llm-gateway/HTTPResponse.swift"
            ]
        ),
        .target(name: "LLMGatewayClientSDK", path: "Generated/Client/llm-gateway"),
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
            dependencies: [
                "IntegrationRuntime",
                "BaselineAwarenessService", "BaselineAwarenessClient",
                "BootstrapService", "BootstrapClient",
                "PersistService", "PersistClient",
                "FunctionCallerService", "FunctionCallerClient",
                "PlannerService", "PlannerClient",
                "ToolsFactoryService", "ToolsFactoryClient",
                "LLMGatewayService", "LLMGatewayClientSDK"
            ],
            resources: []
        )
    ]
)
