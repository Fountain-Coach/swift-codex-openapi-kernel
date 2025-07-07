import Foundation
import ServiceShared

public struct HTTPKernel {
    let router: Router

    public init(handlers: Handlers = Handlers()) {
        self.router = Router(handlers: handlers)
    }

    public func handle(_ request: HTTPRequest) async throws -> HTTPResponse {
        let resp = try await router.route(request)
        await PrometheusAdapter.shared.record(service: "planner", path: request.path)
        return resp
    }
}
