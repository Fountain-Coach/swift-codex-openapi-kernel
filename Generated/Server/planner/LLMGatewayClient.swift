import Foundation

/// Minimal client for the LLM Gateway. In this stub it simply echoes the
/// objective to demonstrate integration without network dependencies.
struct LLMGatewayClient {
    func chat(objective: String) async throws -> String {
        // In a real implementation this would POST to the LLM Gateway service.
        return "Plan for: \(objective)"
    }
}
