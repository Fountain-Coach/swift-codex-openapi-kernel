import Foundation
import FoundationNetworking
import NIOCore
import NIOHTTP1

public struct URLSessionHTTPClient: HTTPClientProtocol {
    let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func execute(method: HTTPMethod, url: String, headers: HTTPHeaders = HTTPHeaders(), body: ByteBuffer?) async throws -> (ByteBuffer, HTTPHeaders) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        if let body = body {
            request.httpBody = Data(body.readableBytesView)
        }
        let (data, response) = try await session.data(for: request)
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)
        var respHeaders = HTTPHeaders()
        if let http = response as? HTTPURLResponse {
            for (key, value) in http.allHeaderFields {
                if let k = key as? String, let v = value as? String { respHeaders.add(name: k, value: v) }
            }
        }
        return (buffer, respHeaders)
    }
}
