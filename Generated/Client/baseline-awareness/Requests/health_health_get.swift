import Foundation

public struct health_health_get: APIRequest {
    public typealias Body = NoBody
    public typealias Response = health_health_getResponse
    public var method: String { "GET" }
    public var path: String { "/health" }
    public var body: Body?

    public init(body: Body? = nil) {
        self.body = body
    }
}
