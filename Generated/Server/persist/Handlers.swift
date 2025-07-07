import Foundation
import ServiceShared

/// Persistence handlers wired to an in-memory Typesense client. This mimics the
/// real Typesense-backed service without requiring the dependency during tests.

public struct Handlers {
    let typesense: TypesenseClient

    public init(typesense: TypesenseClient = .shared) {
        self.typesense = typesense
    }
    public func addbaseline(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let corpusId = request.path.split(separator: "/").dropFirst(2).first,
              let model = try? JSONDecoder().decode(Baseline.self, from: request.body) else {
            return HTTPResponse(status: 400)
        }
        await typesense.addBaseline(model)
        let data = try JSONEncoder().encode(SuccessResponse(message: "stored"))
        return HTTPResponse(body: data)
    }

    public func listreflections(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let corpusId = request.path.split(separator: "/").dropFirst(2).first else {
            return HTTPResponse(status: 400)
        }
        let count = await typesense.reflectionCount(for: String(corpusId))
        let data = try JSONEncoder().encode(["count": count])
        return HTTPResponse(body: data)
    }

    public func addreflection(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let corpusId = request.path.split(separator: "/").dropFirst(2).first,
              let reflection = try? JSONDecoder().decode(Reflection.self, from: request.body) else {
            return HTTPResponse(status: 400)
        }
        await typesense.addReflection(reflection)
        let data = try JSONEncoder().encode(SuccessResponse(message: "stored"))
        return HTTPResponse(body: data)
    }
    public func listcorpora(_ request: HTTPRequest) async throws -> HTTPResponse {
        let ids = await typesense.listCorpora()
        let data = try JSONEncoder().encode(ids)
        return HTTPResponse(body: data)
    }

    public func createcorpus(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let model = try? JSONDecoder().decode(CorpusCreateRequest.self, from: request.body) else {
            return HTTPResponse(status: 400)
        }
        let resp = await typesense.createCorpus(id: model.corpusId)
        let data = try JSONEncoder().encode(resp)
        return HTTPResponse(body: data)
    }

    public func listfunctions(_ request: HTTPRequest) async throws -> HTTPResponse {
        let items = await typesense.listFunctions()
        let data = try JSONEncoder().encode(items)
        return HTTPResponse(body: data)
    }

    public func addfunction(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let function = try? JSONDecoder().decode(ServiceShared.Function.self, from: request.body) else {
            return HTTPResponse(status: 400)
        }
        await typesense.addFunction(function)
        let resp = SuccessResponse(message: "stored")
        let data = try JSONEncoder().encode(resp)
        return HTTPResponse(body: data)
    }

    public func getfunctiondetails(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let id = request.path.split(separator: "/").last else {
            return HTTPResponse(status: 404)
        }
        guard let fn = await typesense.functionDetails(id: String(id)) else {
            return HTTPResponse(status: 404)
        }
        let data = try JSONEncoder().encode(fn)
        return HTTPResponse(body: data)
    }
}
