import Foundation
import Parser

public enum ServerGenerator {
    public static func emitServer(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        try emitHTTPRequest(to: url)
        try emitHTTPResponse(to: url)
        try emitHandlers(from: spec, to: url)
        try emitRouter(from: spec, to: url)
        try emitKernel(to: url)
    }

    private static func emitHTTPRequest(to url: URL) throws {
        let output = """
        public struct HTTPRequest {
            public let method: String
            public let path: String
        }
        """
        try output.write(to: url.appendingPathComponent("HTTPRequest.swift"), atomically: true, encoding: .utf8)
    }

    private static func emitHTTPResponse(to url: URL) throws {
        let output = """
        import Foundation

        public struct HTTPResponse {
            public var status: Int
            public var body: Data

            public init(status: Int = 200, body: Data = Data()) {
                self.status = status
                self.body = body
            }
        }
        """
        try output.write(to: url.appendingPathComponent("HTTPResponse.swift"), atomically: true, encoding: .utf8)
    }

    private static func emitHandlers(from spec: OpenAPISpec, to url: URL) throws {
        var output = "import Foundation\n\npublic struct Handlers {\n    public init() {}\n"
        if let paths = spec.paths {
            for (_, item) in paths {
                if let op = item.get {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
                }
                if let op = item.post {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
                }
                if let op = item.put {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
                }
                if let op = item.delete {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
                }
            }
        }
        output += "}\n"
        try output.write(to: url.appendingPathComponent("Handlers.swift"), atomically: true, encoding: .utf8)
    }

    private static func emitRouter(from spec: OpenAPISpec, to url: URL) throws {
        var output = "import Foundation\n\npublic struct Router {\n    public var handlers: Handlers\n\n    public init(handlers: Handlers = Handlers()) {\n        self.handlers = handlers\n    }\n\n    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {\n        switch (request.method, request.path) {\n"
        if let paths = spec.paths {
            for (path, item) in paths {
                if let op = item.get {
                    output += "        case (\"GET\", \"\(path)\"):\n            return try await handlers.\(op.operationId.camelCased)(request)\n"
                }
                if let op = item.post {
                    output += "        case (\"POST\", \"\(path)\"):\n            return try await handlers.\(op.operationId.camelCased)(request)\n"
                }
                if let op = item.put {
                    output += "        case (\"PUT\", \"\(path)\"):\n            return try await handlers.\(op.operationId.camelCased)(request)\n"
                }
                if let op = item.delete {
                    output += "        case (\"DELETE\", \"\(path)\"):\n            return try await handlers.\(op.operationId.camelCased)(request)\n"
                }
            }
        }
        output += "        default:\n            return HTTPResponse(status: 404)\n        }\n    }\n}\n"
        try output.write(to: url.appendingPathComponent("Router.swift"), atomically: true, encoding: .utf8)
    }

    private static func emitKernel(to url: URL) throws {
        let output = """
        import Foundation

        public struct HTTPKernel {
            let router: Router

            public init(handlers: Handlers = Handlers()) {
                self.router = Router(handlers: handlers)
            }

            public func handle(_ request: HTTPRequest) async throws -> HTTPResponse {
                try await router.route(request)
            }
        }
        """
        try output.write(to: url.appendingPathComponent("HTTPKernel.swift"), atomically: true, encoding: .utf8)
    }
}

private extension String {
    var camelCased: String {
        guard !isEmpty else { return self }
        let parts = split(separator: "_")
        guard let first = parts.first else { return self }
        let rest = parts.dropFirst().map { $0.capitalized }
        return ([first.lowercased()] + rest).joined()
    }
}
