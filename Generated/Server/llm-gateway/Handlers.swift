import Foundation
import ServiceShared

public struct Handlers {
    public init() {}
    public func chatwithobjective(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func metricsMetricsGet(_ request: HTTPRequest) async throws -> HTTPResponse {
        let text = PrometheusAdapter.shared.exposition()
        return HTTPResponse(status: 200, headers: ["Content-Type": "text/plain"], body: Data(text.utf8))
    }
}
