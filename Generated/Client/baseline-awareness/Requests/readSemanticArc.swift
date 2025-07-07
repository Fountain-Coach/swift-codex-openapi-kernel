import Foundation

public struct readSemanticArcParameters: Codable {
    public let corpusId: String
}

public struct readSemanticArc: APIRequest {
    public typealias Body = NoBody
    public typealias Response = readSemanticArcResponse
    public var method: String { "GET" }
    public var parameters: readSemanticArcParameters
    public var path: String {
        var path = "/corpus/semantic-arc"
        var query: [String] = []
        query.append("corpus_id=\(parameters.corpusId)")
        if !query.isEmpty { path += "?" + query.joined(separator: "&") }
        return path
    }
    public var body: Body?

    public init(parameters: readSemanticArcParameters, body: Body? = nil) {
        self.parameters = parameters
        self.body = body
    }
}
