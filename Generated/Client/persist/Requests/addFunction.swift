import Foundation

public struct addFunction: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/corpora/{corpusId}/functions" }
}
