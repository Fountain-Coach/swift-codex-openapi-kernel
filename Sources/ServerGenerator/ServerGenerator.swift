import Foundation
import Parser

public enum ServerGenerator {
    public static func emitServer(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        try emitHTTPRequest(to: url)
        try emitHTTPResponse(to: url)
        try emitHTTPServer(to: url)
        try emitHandlers(from: spec, to: url)
        try emitRouter(from: spec, to: url)
        try emitKernel(to: url)
    }

    private static func emitHTTPRequest(to url: URL) throws {
        let output = """
        import Foundation

        public struct NoBody: Codable {}

        public struct HTTPRequest {
            public let method: String
            public let path: String
            public var headers: [String: String]
            public var body: Data

            public init(method: String, path: String, headers: [String: String] = [:], body: Data = Data()) {
                self.method = method
                self.path = path
                self.headers = headers
                self.body = body
            }
        }
        """
        try (output + "\n").write(to: url.appendingPathComponent("HTTPRequest.swift"), atomically: true, encoding: .utf8)
    }

    private static func emitHTTPResponse(to url: URL) throws {
        let output = """
        import Foundation

        public struct HTTPResponse {
            public var status: Int
            public var headers: [String: String]
            public var body: Data

            public init(status: Int = 200, headers: [String: String] = [:], body: Data = Data()) {
                self.status = status
                self.headers = headers
                self.body = body
            }
        }
        """
        try (output + "\n").write(to: url.appendingPathComponent("HTTPResponse.swift"), atomically: true, encoding: .utf8)
    }

    private static func emitHandlers(from spec: OpenAPISpec, to url: URL) throws {
        var output = "import Foundation\n\npublic struct Handlers {\n    public init() {}\n"
        if let paths = spec.paths {
            for (_, item) in paths {
                if let op = item.get {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest, body: \(bodyType(for: op))?) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
                }
                if let op = item.post {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest, body: \(bodyType(for: op))?) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
                }
                if let op = item.put {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest, body: \(bodyType(for: op))?) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
                }
                if let op = item.delete {
                    output += "    public func \(op.operationId.camelCased)(_ request: HTTPRequest, body: \(bodyType(for: op))?) async throws -> HTTPResponse {\n        return HTTPResponse()\n    }\n"
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
                    output += "        case (\"GET\", \"\(path)\"):\n            let body = try? JSONDecoder().decode(\(bodyType(for: op)).self, from: request.body)\n            return try await handlers.\(op.operationId.camelCased)(request, body: body)\n"
                }
                if let op = item.post {
                    output += "        case (\"POST\", \"\(path)\"):\n            let body = try? JSONDecoder().decode(\(bodyType(for: op)).self, from: request.body)\n            return try await handlers.\(op.operationId.camelCased)(request, body: body)\n"
                }
                if let op = item.put {
                    output += "        case (\"PUT\", \"\(path)\"):\n            let body = try? JSONDecoder().decode(\(bodyType(for: op)).self, from: request.body)\n            return try await handlers.\(op.operationId.camelCased)(request, body: body)\n"
                }
                if let op = item.delete {
                    output += "        case (\"DELETE\", \"\(path)\"):\n            let body = try? JSONDecoder().decode(\(bodyType(for: op)).self, from: request.body)\n            return try await handlers.\(op.operationId.camelCased)(request, body: body)\n"
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
        try (output + "\n").write(to: url.appendingPathComponent("HTTPKernel.swift"), atomically: true, encoding: .utf8)
    }

    private static func emitHTTPServer(to url: URL) throws {
        let output = """
        import Foundation

        public class HTTPServer: URLProtocol {
            static var kernel: HTTPKernel?

            public static func register(kernel: HTTPKernel) {
                self.kernel = kernel
                URLProtocol.registerClass(HTTPServer.self)
            }

            public override class func canInit(with request: URLRequest) -> Bool {
                request.url?.host == "localhost"
            }

            public override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

            override public func startLoading() {
                guard let kernel = HTTPServer.kernel, let url = request.url else {
                    client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
                    return
                }
                let req = HTTPRequest(method: request.httpMethod ?? "GET", path: url.path, headers: request.allHTTPHeaderFields ?? [:], body: request.httpBody ?? Data())
                Task {
                    do {
                        let resp = try await kernel.handle(req)
                        let httpResponse = HTTPURLResponse(url: url, statusCode: resp.status, httpVersion: "HTTP/1.1", headerFields: resp.headers)!
                        client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
                        client?.urlProtocol(self, didLoad: resp.body)
                        client?.urlProtocolDidFinishLoading(self)
                    } catch {
                        client?.urlProtocol(self, didFailWithError: error)
                    }
                }
            }

            override public func stopLoading() {}
        }
        """
        try (output + "\n").write(to: url.appendingPathComponent("HTTPServer.swift"), atomically: true, encoding: .utf8)
    }

    private static func bodyType(for op: OpenAPISpec.Operation) -> String {
        guard let schema = op.requestBody?.content["application/json"]?.schema else {
            return "NoBody"
        }
        if schema.ref == nil {
            return "\(op.operationId)Request"
        }
        return schema.swiftType
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
