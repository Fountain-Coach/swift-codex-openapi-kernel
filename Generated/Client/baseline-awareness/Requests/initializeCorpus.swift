import Foundation

public struct initializeCorpus: APIRequest {
    public typealias Body = InitIn
    public typealias Response = InitOut
    public var method: String { "POST" }
    public var path: String { "/corpus/init" }
    public var body: Body?

    public init(body: Body? = nil) {
        self.body = body
    }
}
