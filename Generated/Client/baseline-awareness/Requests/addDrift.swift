import Foundation

public struct addDrift: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/corpus/drift" }
}
