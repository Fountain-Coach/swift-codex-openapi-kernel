import Foundation

public struct addReflection: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/corpus/reflections" }
}
