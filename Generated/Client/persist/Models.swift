// Models for FountainAI Persistence Service (Typesense-backed)

public struct BaseEntity: Codable {
    public let corpusId: String
}

public struct CorpusCreateRequest: Codable {
    public let corpusId: String
}

public struct CorpusResponse: Codable {
    public let corpusId: String
    public let message: String
}

public struct Function: Codable {
    public let description: String
    public let functionId: String
    public let httpMethod: String
    public let httpPath: String
    public let name: String
}

public struct SuccessResponse: Codable {
    public let message: String
}

