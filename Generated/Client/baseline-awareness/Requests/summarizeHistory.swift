import Foundation

public struct summarizeHistoryParameters: Codable {
    public let corpusId: String
}

public struct summarizeHistory: APIRequest {
    public typealias Body = NoBody
    public typealias Response = HistorySummaryResponse
    public var method: String { "GET" }
    public var parameters: summarizeHistoryParameters
    public var path: String {
        var path = "/corpus/summary/{corpus_id}"
        var query: [String] = []
        path = path.replacingOccurrences(of: "{corpus_id}", with: String(parameters.corpusId))
        if !query.isEmpty { path += "?" + query.joined(separator: "&") }
        return path
    }
    public var body: Body?

    public init(parameters: summarizeHistoryParameters, body: Body? = nil) {
        self.parameters = parameters
        self.body = body
    }
}
