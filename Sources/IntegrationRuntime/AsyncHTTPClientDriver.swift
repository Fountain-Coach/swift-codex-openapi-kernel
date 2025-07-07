import AsyncHTTPClient
import NIOCore
import NIOHTTP1

public final class AsyncHTTPClientDriver: HTTPClientProtocol {
    let client: HTTPClient

    public init(eventLoopGroupProvider: HTTPClient.EventLoopGroupProvider = .createNew) {
        self.client = HTTPClient(eventLoopGroupProvider: eventLoopGroupProvider)
    }

    public func execute(method: HTTPMethod, url: String, headers: HTTPHeaders = HTTPHeaders(), body: ByteBuffer?) async throws -> (ByteBuffer, HTTPHeaders) {
        var request = HTTPClientRequest(url: url)
        request.method = method
        request.headers = headers
        if let body = body {
            request.body = .bytes(body)
        }
        let response = try await client.execute(request, timeout: .seconds(5))
        let bytes = try await response.body.collect(upTo: 1 << 20)
        return (bytes, response.headers)
    }

    public func shutdown() async throws {
        try await client.shutdown()
    }
}
