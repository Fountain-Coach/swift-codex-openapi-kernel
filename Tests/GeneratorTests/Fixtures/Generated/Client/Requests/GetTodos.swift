import Foundation

public struct GetTodos: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/todos" }
}
