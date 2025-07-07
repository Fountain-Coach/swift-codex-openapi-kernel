import Foundation

public struct initializeCorpus: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/corpus/init" }
}
