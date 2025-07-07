import Foundation

public struct addBaseline: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/corpora/{corpusId}/baselines" }
}
