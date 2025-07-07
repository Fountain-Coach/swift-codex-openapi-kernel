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
        return HTTPResponse()
    }
    public func listreflections(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
    }
    public func addreflection(_ request: HTTPRequest) async throws -> HTTPResponse {
        return HTTPResponse()
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
        guard let function = try? JSONDecoder().decode(Function.self, from: request.body) else {
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
