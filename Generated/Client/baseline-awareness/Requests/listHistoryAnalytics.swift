import Foundation

public struct listHistoryAnalyticsParameters: Codable {
    public let corpusId: String
}

public struct listHistoryAnalytics: APIRequest {
    public typealias Body = NoBody
    public typealias Response = listHistoryAnalyticsResponse
    public var method: String { "GET" }
    public var parameters: listHistoryAnalyticsParameters
    public var path: String {
        var path = "/corpus/history"
        var query: [String] = []
        query.append("corpus_id=\(parameters.corpusId)")
        if !query.isEmpty { path += "?" + query.joined(separator: "&") }
        return path
    }
    public var body: Body?

    public init(parameters: listHistoryAnalyticsParameters, body: Body? = nil) {
        self.parameters = parameters
        self.body = body
    }
}
