import Foundation

public struct bootstrapInitializeCorpus: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/bootstrap/corpus/init" }
}
