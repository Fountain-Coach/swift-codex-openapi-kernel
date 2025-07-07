import Foundation
import Parser

public enum ClientGenerator {
    public static func emitClient(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

        let apiRequest = """
        import Foundation

        public protocol APIRequest {
            associatedtype Response: Decodable
            var method: String { get }
            var path: String { get }
        }
        """
        try apiRequest.write(to: url.appendingPathComponent("APIRequest.swift"), atomically: true, encoding: .utf8)

        let apiClient = """
        import Foundation

        public protocol HTTPSession {
            func data(for request: URLRequest) async throws -> (Data, URLResponse)
        }

        extension URLSession: HTTPSession {}

        public struct APIClient {
            let baseURL: URL
            let session: HTTPSession

            public init(baseURL: URL, session: HTTPSession = URLSession.shared) {
                self.baseURL = baseURL
                self.session = session
            }

            public func send<R: APIRequest>(_ request: R) async throws -> R.Response {
                var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
                urlRequest.httpMethod = request.method
                let (data, _) = try await session.data(for: urlRequest)
                return try JSONDecoder().decode(R.Response.self, from: data)
            }
        }
        """
        try apiClient.write(to: url.appendingPathComponent("APIClient.swift"), atomically: true, encoding: .utf8)

        let requestsDir = url.appendingPathComponent("Requests")
        try FileManager.default.createDirectory(at: requestsDir, withIntermediateDirectories: true)

        if let paths = spec.paths {
            for (path, item) in paths {
                if let op = item.get {
                    try emitRequest(named: op.operationId, method: "GET", path: path, in: requestsDir)
                }
                if let op = item.post {
                    try emitRequest(named: op.operationId, method: "POST", path: path, in: requestsDir)
                }
                if let op = item.put {
                    try emitRequest(named: op.operationId, method: "PUT", path: path, in: requestsDir)
                }
                if let op = item.delete {
                    try emitRequest(named: op.operationId, method: "DELETE", path: path, in: requestsDir)
                }
            }
        }
    }

    private static func emitRequest(named name: String, method: String, path: String, in dir: URL) throws {
        let output = """
        import Foundation

        public struct \(name): APIRequest {
            public typealias Response = Data
            public var method: String { "\(method)" }
            public var path: String { "\(path)" }
        }
        """
        try output.write(to: dir.appendingPathComponent("\(name).swift"), atomically: true, encoding: .utf8)
    }
}
