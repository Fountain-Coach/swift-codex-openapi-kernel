import Foundation

public struct list_tools: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/tools" }
}
