// Models for Baseline Awareness Service

public struct BaselineRequest: Codable, Sendable {
    public let baselineId: String
    public let content: String
    public let corpusId: String
}

public struct DriftRequest: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let driftId: String
}

public struct HistorySummaryResponse: Codable, Sendable {
    public let summary: String
}

public struct InitIn: Codable, Sendable {
    public let corpusId: String
}

public struct InitOut: Codable, Sendable {
    public let message: String
}

public struct PatternsRequest: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let patternsId: String
}

public struct ReflectionRequest: Codable, Sendable {
    public let content: String
    public let corpusId: String
    public let question: String
    public let reflectionId: String
}

public struct ReflectionSummaryResponse: Codable, Sendable {
    public let message: String
}

public typealias readSemanticArcResponse = String

public typealias addReflectionResponse = String

public typealias addDriftResponse = String

public typealias listHistoryAnalyticsResponse = String

public typealias addPatternsResponse = String

public typealias health_health_getResponse = String

public typealias addBaselineResponse = String

