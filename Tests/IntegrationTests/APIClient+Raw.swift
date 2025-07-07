import Foundation
import FoundationNetworking
@testable import BaselineAwarenessClient
@testable import BootstrapClient
@testable import PersistClient
@testable import FunctionCallerClient
@testable import PlannerClient
@testable import ToolsFactoryClient
@testable import LLMGatewayClientSDK

// Convenience helpers to bypass JSON decoding for simple tests
extension BaselineAwarenessClient.APIClient {
    func sendRaw<R: BaselineAwarenessClient.APIRequest>(_ request: R) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}

extension BootstrapClient.APIClient {
    func sendRaw<R: BootstrapClient.APIRequest>(_ request: R) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}

extension PersistClient.APIClient {
    func sendRaw<R: PersistClient.APIRequest>(_ request: R) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}

extension FunctionCallerClient.APIClient {
    func sendRaw<R: FunctionCallerClient.APIRequest>(_ request: R) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}

extension PlannerClient.APIClient {
    func sendRaw<R: PlannerClient.APIRequest>(_ request: R) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}

extension ToolsFactoryClient.APIClient {
    func sendRaw<R: ToolsFactoryClient.APIRequest>(_ request: R) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}

extension LLMGatewayClientSDK.APIClient {
    func sendRaw<R: LLMGatewayClientSDK.APIRequest>(_ request: R) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}
