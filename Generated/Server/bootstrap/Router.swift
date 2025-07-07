import Foundation
import ServiceShared

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("POST", "/bootstrap/corpus/reflect"):
            return try await handlers.bootstrapenqueuereflection(request)
        case ("POST", "/bootstrap/corpus/init"):
            return try await handlers.bootstrapinitializecorpus(request)
        case ("POST", "/bootstrap/roles/promote"):
            return try await handlers.bootstrappromotereflection(request)
        case ("POST", "/bootstrap/roles/seed"):
            return try await handlers.bootstrapseedroles(request)
        case ("POST", "/bootstrap/roles"):
            return try await handlers.seedroles(request)
        case ("POST", "/bootstrap/baseline"):
            return try await handlers.bootstrapaddbaseline(request)
        case ("GET", "/metrics"):
            let text = await PrometheusAdapter.shared.exposition()
            return HTTPResponse(status: 200, headers: ["Content-Type": "text/plain"], body: Data(text.utf8))
        default:
            return HTTPResponse(status: 404)
        }
    }
}
