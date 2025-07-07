import Foundation

public struct Handlers {
    public init() {}
    public func addbaseline(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func listreflections(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func addreflection(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func listcorpora(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func createcorpus(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func listfunctions(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func addfunction(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func getfunctiondetails(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
}
