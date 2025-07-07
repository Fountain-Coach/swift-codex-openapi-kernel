import Foundation

public struct Handlers {
    public init() {}
    public func plannerReason(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func getSemanticArc(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func plannerListCorpora(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func getReflectionHistory(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func plannerExecute(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func postReflection(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
}
