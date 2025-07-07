import Foundation

/// Service handlers backed by an in-memory ``BaselineStore``.
public struct Handlers {
    let store: BaselineStore

    public init(store: BaselineStore = .shared) {
        self.store = store
    }

    public func readsemanticarc(_ request: HTTPRequest, body: NoBody?) async throws -> HTTPResponse {
        let comps = URLComponents(string: request.path)
        let corpusId = comps?.queryItems?.first(where: { $0.name == "corpus_id" })?.value
        guard let id = corpusId else {
            return HTTPResponse(status: 400)
        }
        let data = Data("arc for \(id)".utf8)
        return HTTPResponse(body: data)
    }

    public func summarizehistory(_ request: HTTPRequest, body: NoBody?) async throws -> HTTPResponse {
        guard let corpusId = request.path.split(separator: "/").last else {
            return HTTPResponse(status: 404)
        }
        let summary = await store.historySummary(for: String(corpusId))
        let data = try JSONEncoder().encode(summary)
        return HTTPResponse(body: data)
    }

    public func addreflection(_ request: HTTPRequest, body: ReflectionRequest?) async throws -> HTTPResponse {
        guard let model = body else { return HTTPResponse(status: 400) }
        await store.addReflection(model)
        return HTTPResponse()
    }

    public func listhistory(_ request: HTTPRequest, body: NoBody?) async throws -> HTTPResponse {
        guard let corpusId = request.path.split(separator: "/").last else {
            return HTTPResponse(status: 404)
        }
        let summary = await store.historySummary(for: String(corpusId))
        let data = try JSONEncoder().encode(summary)
        return HTTPResponse(body: data)
    }

    public func adddrift(_ request: HTTPRequest, body: DriftRequest?) async throws -> HTTPResponse {
        guard let drift = body else { return HTTPResponse(status: 400) }
        await store.addDrift(drift)
        return HTTPResponse()
    }

    public func listhistoryanalytics(_ request: HTTPRequest, body: NoBody?) async throws -> HTTPResponse {
        let comps = URLComponents(string: request.path)
        let corpusId = comps?.queryItems?.first(where: { $0.name == "corpus_id" })?.value
        guard let id = corpusId else {
            return HTTPResponse(status: 400)
        }
        let data = Data("analytics for \(id)".utf8)
        return HTTPResponse(body: data)
    }

    public func addpatterns(_ request: HTTPRequest, body: PatternsRequest?) async throws -> HTTPResponse {
        guard let patterns = body else { return HTTPResponse(status: 400) }
        await store.addPatterns(patterns)
        return HTTPResponse()
    }

    public func healthHealthGet(_ request: HTTPRequest, body: NoBody?) async throws -> HTTPResponse {
        let json = try JSONEncoder().encode(["status": "ok"])
        return HTTPResponse(status: 200, headers: ["Content-Type": "application/json"], body: json)
    }

    public func listreflections(_ request: HTTPRequest, body: NoBody?) async throws -> HTTPResponse {
        guard let corpusId = request.path.split(separator: "/").last else {
            return HTTPResponse(status: 404)
        }
        let summary = await store.reflectionSummary(for: String(corpusId))
        let data = try JSONEncoder().encode(summary)
        return HTTPResponse(body: data)
    }

    public func initializecorpus(_ request: HTTPRequest, body: InitIn?) async throws -> HTTPResponse {
        guard let initReq = body else { return HTTPResponse(status: 400) }
        let resp = await store.createCorpus(id: initReq.corpusId)
        let data = try JSONEncoder().encode(resp)
        return HTTPResponse(body: data)
    }

    public func addbaseline(_ request: HTTPRequest, body: BaselineRequest?) async throws -> HTTPResponse {
        guard let baseline = body else { return HTTPResponse(status: 400) }
        await store.addBaseline(baseline)
        return HTTPResponse()
    }
}
