import Foundation

public struct Handlers {
    public init() {}
    public func getFunctionDetails(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func listFunctions(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func invokeFunction(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
}
