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

public struct Baseline: Codable, Sendable {
    public let baselineId: String
    public let content: String
    public let corpusId: String
}

public struct Drift: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let driftId: String
}

public struct Patterns: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let patternsId: String
}

public struct Reflection: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let question: String
    public let reflectionId: String
}
