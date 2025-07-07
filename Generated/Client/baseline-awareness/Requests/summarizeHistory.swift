import Foundation

public struct summarizeHistory: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/corpus/summary/{corpus_id}" }
}
