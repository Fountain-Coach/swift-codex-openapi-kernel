import Foundation

public struct addPatterns: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/corpus/patterns" }
}
