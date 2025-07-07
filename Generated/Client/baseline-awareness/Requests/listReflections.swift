import Foundation

public struct listReflectionsParameters: Codable {
    public let corpusId: String
}

public struct listReflections: APIRequest {
    public typealias Body = NoBody
    public typealias Response = ReflectionSummaryResponse
    public var method: String { "GET" }
    public var parameters: listReflectionsParameters
    public var path: String {
        var path = "/corpus/reflections/{corpus_id}"
        var query: [String] = []
        path = path.replacingOccurrences(of: "{corpus_id}", with: String(parameters.corpusId))
        if !query.isEmpty { path += "?" + query.joined(separator: "&") }
        return path
    }
    public var body: Body?

    public init(parameters: listReflectionsParameters, body: Body? = nil) {
        self.parameters = parameters
        self.body = body
    }
}
