import Foundation

public struct listCorpora: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/corpora" }
}
