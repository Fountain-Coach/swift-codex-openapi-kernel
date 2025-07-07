import Foundation

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("POST", "/tools/register"):
            return try await handlers.registerOpenapi(request)
        case ("GET", "/tools"):
            return try await handlers.listTools(request)
        default:
            return HTTPResponse(status: 404)
        }
    }
}
