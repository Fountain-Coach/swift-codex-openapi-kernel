import Foundation
import Parser

public enum ClientGenerator {
    public static func emitClient(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

        let apiRequest = """
        import Foundation

        /// Empty body type used for requests without a payload.
        public struct NoBody: Codable {}

        public protocol APIRequest {
            associatedtype Body: Encodable = NoBody
            associatedtype Response: Decodable
            var method: String { get }
            var path: String { get }
            var body: Body? { get }
        }
        """
        try (apiRequest + "\n").write(to: url.appendingPathComponent("APIRequest.swift"), atomically: true, encoding: .utf8)

        let apiClient = """
        import Foundation
        import FoundationNetworking

        public protocol HTTPSession {
            func data(for request: URLRequest) async throws -> (Data, URLResponse)
        }

        extension URLSession: HTTPSession {
            public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
                try await self.data(for: request, delegate: nil)
            }
        }

        public struct APIClient {
            let baseURL: URL
            let session: HTTPSession
            let defaultHeaders: [String: String]

            public init(baseURL: URL, session: HTTPSession = URLSession.shared, defaultHeaders: [String: String] = [:]) {
                self.baseURL = baseURL
                self.session = session
                self.defaultHeaders = defaultHeaders
            }

            public func send<R: APIRequest>(_ request: R) async throws -> R.Response {
                var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
                urlRequest.httpMethod = request.method
                for (header, value) in defaultHeaders {
                    urlRequest.setValue(value, forHTTPHeaderField: header)
                }
                if let body = request.body {
                    urlRequest.httpBody = try JSONEncoder().encode(body)
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                let (data, _) = try await session.data(for: urlRequest)
                return try JSONDecoder().decode(R.Response.self, from: data)
            }
        }

        public extension APIClient {
            init(baseURL: URL, bearerToken: String, session: HTTPSession = URLSession.shared) {
                self.init(baseURL: baseURL, session: session, defaultHeaders: ["Authorization": "Bearer \\(bearerToken)"])
            }
        }
        """
        try (apiClient + "\n").write(to: url.appendingPathComponent("APIClient.swift"), atomically: true, encoding: .utf8)

        let requestsDir = url.appendingPathComponent("Requests")
        try FileManager.default.createDirectory(at: requestsDir, withIntermediateDirectories: true)

        if let paths = spec.paths {
            for (path, item) in paths {
                if let op = item.get {
                    try emitRequest(operation: op, method: "GET", path: path, in: requestsDir)
                }
                if let op = item.post {
                    try emitRequest(operation: op, method: "POST", path: path, in: requestsDir)
                }
                if let op = item.put {
                    try emitRequest(operation: op, method: "PUT", path: path, in: requestsDir)
                }
                if let op = item.delete {
                    try emitRequest(operation: op, method: "DELETE", path: path, in: requestsDir)
                }
            }
        }
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

    private static func responseType(for op: OpenAPISpec.Operation) -> String {
        guard let schema = op.responses?["200"]?.content?["application/json"]?.schema else {
            return "Data"
        }
        if schema.ref == nil {
            return "\(op.operationId)Response"
        }
        return schema.swiftType
    }

    private static func emitRequest(operation op: OpenAPISpec.Operation, method: String, path: String, in dir: URL) throws {
        let bodyType = bodyType(for: op)
        let responseType = responseType(for: op)
        var output = "import Foundation\n\n"

        if let params = op.parameters, !params.isEmpty {
            output += "public struct \(op.operationId)Parameters: Codable {\n"
            for param in params {
                let name = param.swiftName.camelCased
                let type = param.swiftType
                if param.required == true {
                    output += "    public let \(name): \(type)\n"
                } else {
                    output += "    public var \(name): \(type)?\n"
                }
            }
            output += "}\n\n"
        }

        output += "public struct \(op.operationId): APIRequest {\n"
        output += "    public typealias Body = \(bodyType)\n"
        output += "    public typealias Response = \(responseType)\n"
        output += "    public var method: String { \"\(method)\" }\n"
        if let params = op.parameters, !params.isEmpty {
            output += "    public var parameters: \(op.operationId)Parameters\n"
            output += "    public var path: String {\n"
            output += "        var path = \"\(path)\"\n"
            output += "        var query: [String] = []\n"
            for param in params {
                let name = param.swiftName.camelCased
                if param.location == "path" {
                    output += "        path = path.replacingOccurrences(of: \"{\(param.name)}\", with: String(parameters.\(name)))\n"
                } else if param.location == "query" {
                    if param.required == true {
                        output += "        query.append(\"\(param.name)=\\(parameters.\(name))\")\n"
                    } else {
                        output += "        if let value = parameters.\(name) { query.append(\"\(param.name)=\\(value)\") }\n"
                    }
                }
            }
            output += "        if !query.isEmpty { path += \"?\" + query.joined(separator: \"&\") }\n"
            output += "        return path\n"
            output += "    }\n"
        } else {
            output += "    public var path: String { \"\(path)\" }\n"
        }
        output += "    public var body: Body?\n\n"
        if let params = op.parameters, !params.isEmpty {
            output += "    public init(parameters: \(op.operationId)Parameters, body: Body? = nil) {\n"
            output += "        self.parameters = parameters\n"
            output += "        self.body = body\n"
            output += "    }\n"
        } else {
            output += "    public init(body: Body? = nil) {\n"
            output += "        self.body = body\n"
            output += "    }\n"
        }
        output += "}\n"

        try output.write(to: dir.appendingPathComponent("\(op.operationId).swift"), atomically: true, encoding: .utf8)
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
