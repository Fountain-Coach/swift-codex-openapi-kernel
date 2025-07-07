import Foundation

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("GET", "/health"):
            return try await handlers.healthHealthGet(request)
        case ("POST", "/corpus/init"):
            return try await handlers.initializecorpus(request)
        case ("GET", "/corpus/semantic-arc"):
            return try await handlers.readsemanticarc(request)
        case ("GET", "/corpus/reflections/{corpus_id}"):
            return try await handlers.listreflections(request)
        case ("POST", "/corpus/patterns"):
            return try await handlers.addpatterns(request)
        case ("GET", "/corpus/history"):
            return try await handlers.listhistoryanalytics(request)
        case ("POST", "/corpus/drift"):
            return try await handlers.adddrift(request)
        case ("GET", "/corpus/history/{corpus_id}"):
            return try await handlers.listhistory(request)
        case ("POST", "/corpus/reflections"):
            return try await handlers.addreflection(request)
        case ("GET", "/corpus/summary/{corpus_id}"):
            return try await handlers.summarizehistory(request)
        case ("POST", "/corpus/baseline"):
            return try await handlers.addbaseline(request)
        default:
            return HTTPResponse(status: 404)
        }
    }
}
