import XCTest
import IntegrationRuntime
import NIOHTTP1

@testable import BaselineAwarenessService
@testable import BaselineAwarenessClient
@testable import BootstrapService
@testable import BootstrapClient
@testable import PersistService
@testable import PersistClient
@testable import FunctionCallerService
@testable import FunctionCallerClient
@testable import PlannerService
@testable import PlannerClient
@testable import ToolsFactoryService
@testable import ToolsFactoryClient
@testable import LLMGatewayService
@testable import LLMGatewayClientSDK

final class ServicesIntegrationTests: XCTestCase {
    func startServer(with kernel: IntegrationRuntime.HTTPKernel) async throws -> (NIOHTTPServer, Int) {
        let server = NIOHTTPServer(kernel: kernel)
        let port = try await server.start(port: 0)
        return (server, port)
    }

    func testBaselineAwarenessHealth() async throws {
        let serviceKernel = BaselineAwarenessService.HTTPKernel()
        let kernel = IntegrationRuntime.HTTPKernel { req in
            let sreq = BaselineAwarenessService.HTTPRequest(method: req.method, path: req.path, headers: req.headers, body: req.body)
            let sresp = try await serviceKernel.handle(sreq)
            return IntegrationRuntime.HTTPResponse(status: sresp.status, body: sresp.body)
        }
        let (server, port) = try await startServer(with: kernel)
        defer { try? await server.stop() }

        let client = BaselineAwarenessClient.APIClient(baseURL: URL(string: "http://127.0.0.1:\(port)")!)
        let data = try await client.sendRaw(BaselineAwarenessClient.health_health_get())
        XCTAssertEqual(data.count, 0)
    }

    func testBootstrapSeedRoles() async throws {
        let serviceKernel = BootstrapService.HTTPKernel()
        let kernel = IntegrationRuntime.HTTPKernel { req in
            let sreq = BootstrapService.HTTPRequest(method: req.method, path: req.path, headers: req.headers, body: req.body)
            let sresp = try await serviceKernel.handle(sreq)
            return IntegrationRuntime.HTTPResponse(status: sresp.status, body: sresp.body)
        }
        let (server, port) = try await startServer(with: kernel)
        defer { try? await server.stop() }

        let client = BootstrapClient.APIClient(baseURL: URL(string: "http://127.0.0.1:\(port)")!)
        let data = try await client.sendRaw(BootstrapClient.seedRoles())
        XCTAssertEqual(data.count, 0)
    }

    func testPersistListCorpora() async throws {
        _ = await PersistService.TypesenseClient.shared.createCorpus(id: "c1")
        let serviceKernel = PersistService.HTTPKernel()
        let kernel = IntegrationRuntime.HTTPKernel { req in
            let sreq = PersistService.HTTPRequest(method: req.method, path: req.path, headers: req.headers, body: req.body)
            let sresp = try await serviceKernel.handle(sreq)
            return IntegrationRuntime.HTTPResponse(status: sresp.status, body: sresp.body)
        }
        let (server, port) = try await startServer(with: kernel)
        defer { try? await server.stop() }

        let client = PersistClient.APIClient(baseURL: URL(string: "http://127.0.0.1:\(port)")!)
        let data = try await client.sendRaw(PersistClient.listCorpora())
        let ids = try JSONDecoder().decode([String].self, from: data)
        XCTAssertEqual(ids, ["c1"])
    }

    func testFunctionCallerListFunctions() async throws {
        let fn = FunctionCallerService.Function(description: "test", function_id: "f1", http_method: "GET", http_path: "http://example.com", name: "fn", parameters_schema: "{}")
        await FunctionCallerService.TypesenseClient.shared.addFunction(fn)
        let serviceKernel = FunctionCallerService.HTTPKernel()
        let kernel = IntegrationRuntime.HTTPKernel { req in
            let sreq = FunctionCallerService.HTTPRequest(method: req.method, path: req.path, headers: req.headers, body: req.body)
            let sresp = try await serviceKernel.handle(sreq)
            return IntegrationRuntime.HTTPResponse(status: sresp.status, body: sresp.body)
        }
        let (server, port) = try await startServer(with: kernel)
        defer { try? await server.stop() }

        let client = FunctionCallerClient.APIClient(baseURL: URL(string: "http://127.0.0.1:\(port)")!)
        let data = try await client.sendRaw(FunctionCallerClient.list_functions())
        let items = try JSONDecoder().decode([FunctionCallerClient.FunctionInfo].self, from: data)
        XCTAssertEqual(items.first?.function_id, "f1")
    }

    func testPlannerListCorpora() async throws {
        _ = await PlannerService.TypesenseClient.shared.createCorpus(id: "p1")
        let serviceKernel = PlannerService.HTTPKernel()
        let kernel = IntegrationRuntime.HTTPKernel { req in
            let sreq = PlannerService.HTTPRequest(method: req.method, path: req.path, headers: req.headers, body: req.body)
            let sresp = try await serviceKernel.handle(sreq)
            return IntegrationRuntime.HTTPResponse(status: sresp.status, body: sresp.body)
        }
        let (server, port) = try await startServer(with: kernel)
        defer { try? await server.stop() }

        let client = PlannerClient.APIClient(baseURL: URL(string: "http://127.0.0.1:\(port)")!)
        let data = try await client.sendRaw(PlannerClient.planner_list_corpora())
        let ids = try JSONDecoder().decode([String].self, from: data)
        XCTAssertEqual(ids, ["p1"])
    }

    func testToolsFactoryListTools() async throws {
        let serviceKernel = ToolsFactoryService.HTTPKernel()
        let kernel = IntegrationRuntime.HTTPKernel { req in
            let sreq = ToolsFactoryService.HTTPRequest(method: req.method, path: req.path, headers: req.headers, body: req.body)
            let sresp = try await serviceKernel.handle(sreq)
            return IntegrationRuntime.HTTPResponse(status: sresp.status, body: sresp.body)
        }
        let (server, port) = try await startServer(with: kernel)
        defer { try? await server.stop() }

        let client = ToolsFactoryClient.APIClient(baseURL: URL(string: "http://127.0.0.1:\(port)")!)
        let data = try await client.sendRaw(ToolsFactoryClient.list_tools())
        XCTAssertEqual(data.count, 0)
    }

    func testLLMGatewayMetrics() async throws {
        let serviceKernel = LLMGatewayService.HTTPKernel()
        let kernel = IntegrationRuntime.HTTPKernel { req in
            let sreq = LLMGatewayService.HTTPRequest(method: req.method, path: req.path, headers: req.headers, body: req.body)
            let sresp = try await serviceKernel.handle(sreq)
            return IntegrationRuntime.HTTPResponse(status: sresp.status, body: sresp.body)
        }
        let (server, port) = try await startServer(with: kernel)
        defer { try? await server.stop() }

        let client = LLMGatewayClientSDK.APIClient(baseURL: URL(string: "http://127.0.0.1:\(port)")!)
        let data = try await client.sendRaw(LLMGatewayClientSDK.metrics_metrics_get())
        XCTAssertEqual(data.count, 0)
    }
}
