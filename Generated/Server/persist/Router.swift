import Foundation
import ServiceShared

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("POST", "/corpora/{corpusId}/baselines"):
            return try await handlers.addbaseline(request)
        case ("GET", "/corpora/{corpusId}/reflections"):
            return try await handlers.listreflections(request)
        case ("POST", "/corpora/{corpusId}/reflections"):
            return try await handlers.addreflection(request)
        case ("GET", "/corpora"):
            return try await handlers.listcorpora(request)
        case ("POST", "/corpora"):
            return try await handlers.createcorpus(request)
        case ("GET", "/functions"):
            return try await handlers.listfunctions(request)
        case ("POST", "/corpora/{corpusId}/functions"):
            return try await handlers.addfunction(request)
        case ("GET", "/functions/{functionId}"):
            return try await handlers.getfunctiondetails(request)
        case ("GET", "/metrics"):
            let text = await PrometheusAdapter.shared.exposition()
            return HTTPResponse(status: 200, headers: ["Content-Type": "text/plain"], body: Data(text.utf8))
        default:
            return HTTPResponse(status: 404)
        }
    }
}
