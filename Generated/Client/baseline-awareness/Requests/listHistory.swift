import Foundation

public struct listHistory: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/corpus/history/{corpus_id}" }
}
