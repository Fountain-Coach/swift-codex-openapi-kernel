import Foundation

public struct Handlers {
    public init() {}
    public func registerOpenapi(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func listTools(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
}
