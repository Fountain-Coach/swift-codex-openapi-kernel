import Foundation

public struct invoke_function: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/functions/{function_id}/invoke" }
}
