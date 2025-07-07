import Foundation

public struct health_health_get: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/health" }
}
