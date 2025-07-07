import Foundation

public struct readSemanticArc: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/corpus/semantic-arc" }
}
