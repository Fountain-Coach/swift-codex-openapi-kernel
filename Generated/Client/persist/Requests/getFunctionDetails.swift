import Foundation

public struct getFunctionDetails: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/functions/{functionId}" }
}
