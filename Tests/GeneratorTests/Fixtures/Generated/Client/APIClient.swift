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
        self.init(baseURL: baseURL, session: session, defaultHeaders: ["Authorization": "Bearer \(bearerToken)"])
    }
}
