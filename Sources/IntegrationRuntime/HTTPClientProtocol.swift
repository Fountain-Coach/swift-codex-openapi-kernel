import NIOCore
import NIOHTTP1

public protocol HTTPClientProtocol {
    func execute(method: HTTPMethod, url: String, headers: HTTPHeaders, body: ByteBuffer?) async throws -> (ByteBuffer, HTTPHeaders)
}
