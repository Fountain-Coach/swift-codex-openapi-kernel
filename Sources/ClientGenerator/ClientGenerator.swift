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

        extension URLSession: HTTPSession {}

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
        let output = """
        import Foundation

        public struct \(op.operationId): APIRequest {
            public typealias Body = \(bodyType)
            public typealias Response = \(responseType)
            public var method: String { \"\(method)\" }
            public var path: String { \"\(path)\" }
            public var body: Body?

            public init(body: Body? = nil) {
                self.body = body
            }
        }
        """
        try (output + "\n").write(to: dir.appendingPathComponent("\(op.operationId).swift"), atomically: true, encoding: .utf8)
    }
}
