import Foundation

public struct get_semantic_arc: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/planner/reflections/{corpus_id}/semantic-arc" }
}
