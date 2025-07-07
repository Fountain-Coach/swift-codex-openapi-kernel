// Models for FountainAI Function Caller Service

public struct ErrorResponse: Codable {
    public let error_code: String
    public let message: String
}

public struct FunctionInfo: Codable {
    public let description: String
    public let function_id: String
    public let http_method: String
    public let http_path: String
    public let name: String
    public let parameters_schema: String
}

