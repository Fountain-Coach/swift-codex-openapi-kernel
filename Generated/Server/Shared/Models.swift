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

    public init(baselineId: String, content: String, corpusId: String) {
        self.baselineId = baselineId
        self.content = content
        self.corpusId = corpusId
    }
}

public struct Drift: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let driftId: String

    public init(content: String, corpusId: String, driftId: String) {
        self.content = content
        self.corpusId = corpusId
        self.driftId = driftId
    }
}

public struct Patterns: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let patternsId: String

    public init(content: String, corpusId: String, patternsId: String) {
        self.content = content
        self.corpusId = corpusId
        self.patternsId = patternsId
    }
}

public struct Reflection: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let question: String
    public let reflectionId: String

    public init(content: String, corpusId: String, question: String, reflectionId: String) {
        self.content = content
        self.corpusId = corpusId
        self.question = question
        self.reflectionId = reflectionId
    }
}
