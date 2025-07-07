import Foundation

public struct listReflections: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/corpus/reflections/{corpus_id}" }
}
