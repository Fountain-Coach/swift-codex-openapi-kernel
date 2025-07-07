public struct CorpusResponse: Codable, Sendable {
    public let corpusId: String
    public let message: String
}

public struct Function: Codable, Sendable {
    public let description: String
    public let functionId: String
    public let httpMethod: String
    public let httpPath: String
    public let name: String
}
