// Models for FountainAI Tools Factory Service

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
    public let openapi: String
    public let parameters_schema: String
}

public struct FunctionListResponse: Codable {
    public let functions: String
    public let page: Int
    public let page_size: Int
    public let total: Int
}

