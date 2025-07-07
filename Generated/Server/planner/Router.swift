import Foundation
import ServiceShared

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("POST", "/planner/reason"):
            return try await handlers.plannerReason(request)
        case ("GET", "/planner/reflections/{corpus_id}/semantic-arc"):
            return try await handlers.getSemanticArc(request)
        case ("GET", "/planner/corpora"):
            return try await handlers.plannerListCorpora(request)
        case ("GET", "/planner/reflections/{corpus_id}"):
            return try await handlers.getReflectionHistory(request)
        case ("POST", "/planner/execute"):
            return try await handlers.plannerExecute(request)
        case ("POST", "/planner/reflections/"):
            return try await handlers.postReflection(request)
        case ("GET", "/metrics"):
            let text = await PrometheusAdapter.shared.exposition()
            return HTTPResponse(status: 200, headers: ["Content-Type": "text/plain"], body: Data(text.utf8))
        default:
            return HTTPResponse(status: 404)
        }
    }
}
