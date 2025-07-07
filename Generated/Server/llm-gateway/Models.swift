// Models for FountainAI LLM Gateway

public struct ChatRequest: Codable {
    public let function_call: String
    public let functions: String
    public let messages: String
    public let model: String
}

public struct FunctionCallObject: Codable {
    public let name: String
}

public struct FunctionObject: Codable {
    public let description: String
    public let name: String
}

public struct HTTPValidationError: Codable {
    public let detail: String
}

public struct MessageObject: Codable {
    public let content: String
    public let role: String
}

public struct ValidationError: Codable {
    public let loc: String
    public let msg: String
    public let type: String
}

