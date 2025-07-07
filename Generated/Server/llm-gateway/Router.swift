import Foundation

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("POST", "/chat"):
            return try await handlers.chatwithobjective(request)
        case ("GET", "/metrics"):
            return try await handlers.metricsMetricsGet(request)
        default:
            return HTTPResponse(status: 404)
        }
    }
}
