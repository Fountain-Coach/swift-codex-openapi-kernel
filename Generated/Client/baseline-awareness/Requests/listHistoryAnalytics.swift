import Foundation

public struct listHistoryAnalytics: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/corpus/history" }
}
