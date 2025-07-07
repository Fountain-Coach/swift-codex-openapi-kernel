import Foundation

public struct bootstrapAddBaseline: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/bootstrap/baseline" }
}
