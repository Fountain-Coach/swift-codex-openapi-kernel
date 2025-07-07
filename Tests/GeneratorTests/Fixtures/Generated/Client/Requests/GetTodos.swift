import Foundation

public struct GetTodos: APIRequest {
    public typealias Body = NoBody
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/todos" }
    public var body: Body?

    public init(body: Body? = nil) {
        self.body = body
    }
}
