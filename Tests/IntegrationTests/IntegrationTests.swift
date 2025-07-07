import XCTest
import IntegrationRuntime
import NIOHTTP1

final class IntegrationTests: XCTestCase {
    func testAsyncHTTPClientRoundTrip() async throws {
        let router = Router()
        let kernel = HTTPKernel { request in
            try await router.route(request)
        }
        let server = NIOHTTPServer(kernel: kernel)
        let port = try await server.start(port: 0)
        defer { try? await server.stop() }

        let client = AsyncHTTPClientDriver()
        defer { try? await client.shutdown() }

        let (buffer, _) = try await client.execute(method: .GET, url: "http://127.0.0.1:\(port)/todos", headers: HTTPHeaders(), body: nil)
        XCTAssertEqual(buffer.readableBytes, 0)
    }
}
