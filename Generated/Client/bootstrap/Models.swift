// Models for FountainAI Bootstrap Service

public struct BaselineIn: Codable {
    public let baselineId: String
    public let content: String
    public let corpusId: String
}

public struct HTTPValidationError: Codable {
    public let detail: String
}

public struct InitIn: Codable {
    public let corpusId: String
}

public struct InitOut: Codable {
    public let message: String
}

public struct RoleDefaults: Codable {
    public let drift: String
    public let history: String
    public let patterns: String
    public let semantic_arc: String
    public let view_creator: String
}

public struct RoleInfo: Codable {
    public let name: String
    public let prompt: String
}

public struct RoleInitRequest: Codable {
    public let corpusId: String
}

public struct ValidationError: Codable {
    public let loc: String
    public let msg: String
    public let type: String
}

