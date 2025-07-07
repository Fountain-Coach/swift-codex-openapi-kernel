// Models for FountainAI Planner Service

public struct ChatReflectionRequest: Codable {
    public let corpus_id: String
    public let message: String
}

public struct ExecutionResult: Codable {
    public let results: String
}

public struct FunctionCall: Codable {
    public let arguments: String
    public let name: String
}

public struct FunctionCallResult: Codable {
    public let arguments: String
    public let output: String
    public let step: String
}

public struct HTTPValidationError: Codable {
    public let detail: String
}

public struct HistoryListResponse: Codable {
    public let reflections: String
}

public struct PlanExecutionRequest: Codable {
    public let objective: String
    public let steps: String
}

public struct PlanResponse: Codable {
    public let objective: String
    public let steps: String
}

public struct ReflectionItem: Codable {
    public let content: String
    public let timestamp: String
}

public struct UserObjectiveRequest: Codable {
    public let objective: String
}

public struct ValidationError: Codable {
    public let loc: String
    public let msg: String
    public let type: String
}

