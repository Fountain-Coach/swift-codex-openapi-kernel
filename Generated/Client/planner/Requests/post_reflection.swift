import Foundation

public struct post_reflection: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/planner/reflections/" }
}
