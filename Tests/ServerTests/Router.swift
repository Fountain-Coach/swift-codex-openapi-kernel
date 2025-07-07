import Foundation

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("GET", "/todos"):
            let body = try? JSONDecoder().decode(NoBody.self, from: request.body)
            return try await handlers.gettodos(request, body: body)
        default:
            return HTTPResponse(status: 404)
        }
    }
}
