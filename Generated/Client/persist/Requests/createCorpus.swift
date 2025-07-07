import Foundation

public struct createCorpus: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/corpora" }
}
