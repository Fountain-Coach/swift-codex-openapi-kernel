import Foundation

public struct listHistoryParameters: Codable {
    public let corpusId: String
}

public struct listHistory: APIRequest {
    public typealias Body = NoBody
    public typealias Response = HistorySummaryResponse
    public var method: String { "GET" }
    public var parameters: listHistoryParameters
    public var path: String {
        var path = "/corpus/history/{corpus_id}"
        var query: [String] = []
        path = path.replacingOccurrences(of: "{corpus_id}", with: String(parameters.corpusId))
        if !query.isEmpty { path += "?" + query.joined(separator: "&") }
        return path
    }
    public var body: Body?

    public init(parameters: listHistoryParameters, body: Body? = nil) {
        self.parameters = parameters
        self.body = body
    }
}
