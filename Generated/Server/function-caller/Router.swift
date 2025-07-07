import Foundation

public struct Router {
    public var handlers: Handlers

    public init(handlers: Handlers = Handlers()) {
        self.handlers = handlers
    }

    public func route(_ request: HTTPRequest) async throws -> HTTPResponse {
        switch (request.method, request.path) {
        case ("GET", "/functions/{function_id}"):
            return try await handlers.getFunctionDetails(request)
        case ("GET", "/functions"):
            return try await handlers.listFunctions(request)
        case ("POST", "/functions/{function_id}/invoke"):
            return try await handlers.invokeFunction(request)
        default:
            return HTTPResponse(status: 404)
        }
    }
}
