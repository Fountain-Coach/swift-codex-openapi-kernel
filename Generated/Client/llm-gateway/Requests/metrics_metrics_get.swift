import Foundation

public struct metrics_metrics_get: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/metrics" }
}
