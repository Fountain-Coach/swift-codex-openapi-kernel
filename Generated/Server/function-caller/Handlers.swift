import Foundation

/// Implements the Function Caller dispatch mechanism. Registered functions are
/// looked up from the shared TypesenseClient and invoked via URLSession.
public struct Handlers {
    let dispatcher = FunctionDispatcher()

    public init() {}

    public func getFunctionDetails(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let id = request.path.split(separator: "/").last else {
            return HTTPResponse(status: 404)
        }
        guard let fn = TypesenseClient.shared.functionDetails(id: String(id)) else {
            return HTTPResponse(status: 404)
        }
        let data = try JSONEncoder().encode(fn)
        return HTTPResponse(body: data)
    }

    public func listFunctions(_ request: HTTPRequest) async throws -> HTTPResponse {
        let fns = TypesenseClient.shared.listFunctions()
        let data = try JSONEncoder().encode(fns)
        return HTTPResponse(body: data)
    }

    public func invokeFunction(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let id = request.path.split(separator: "/").dropLast().last else {
            return HTTPResponse(status: 404)
        }
        let result = try await dispatcher.invoke(functionId: String(id), payload: request.body)
        return HTTPResponse(body: result)
    }
}
