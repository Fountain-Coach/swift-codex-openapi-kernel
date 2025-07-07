import Foundation

/// Planner handlers integrating with the LLM Gateway stub.
public struct Handlers {
    let llm = LLMGatewayClient()

    public init() {}

    public func plannerReason(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let objective = try? JSONDecoder().decode(UserObjectiveRequest.self, from: request.body).objective else {
            return HTTPResponse(status: 400)
        }
        let steps = try await llm.chat(objective: objective)
        let data = try JSONEncoder().encode(PlanResponse(objective: objective, steps: steps))
        return HTTPResponse(body: data)
    }

    public func getSemanticArc(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func plannerListCorpora(_ request: HTTPRequest) async throws -> HTTPResponse {
        let ids = TypesenseClient.shared.listCorpora()
        let data = try JSONEncoder().encode(ids)
        return HTTPResponse(body: data)
    }
    public func getReflectionHistory(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func plannerExecute(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func postReflection(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
}
