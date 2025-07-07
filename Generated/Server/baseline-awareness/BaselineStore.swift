import Foundation
import ServiceShared

/// In-memory store used by the Baseline Awareness service during tests.
public actor BaselineStore {
    public static let shared = BaselineStore()

    private let typesense: TypesenseClient

    private init(typesense: TypesenseClient = .shared) {
        self.typesense = typesense
    }

    // MARK: - Corpus Management
    public func createCorpus(id: String) async -> InitOut {
        _ = await typesense.createCorpus(id: id)
        return InitOut(message: "created")
    }

    // MARK: - Baseline Data
    public func addBaseline(_ baseline: BaselineRequest) async {
        let item = Baseline(baselineId: baseline.baselineId, content: baseline.content, corpusId: baseline.corpusId)
        await typesense.addBaseline(item)
    }

    public func addDrift(_ drift: DriftRequest) async {
        let item = Drift(content: drift.content, corpusId: drift.corpusId, driftId: drift.driftId)
        await typesense.addDrift(item)
    }

    public func addPatterns(_ patternsReq: PatternsRequest) async {
        let item = Patterns(content: patternsReq.content, corpusId: patternsReq.corpusId, patternsId: patternsReq.patternsId)
        await typesense.addPatterns(item)
    }

    public func addReflection(_ reflection: ReflectionRequest) async {
        let item = Reflection(content: reflection.content, corpusId: reflection.corpusId, question: reflection.question, reflectionId: reflection.reflectionId)
        await typesense.addReflection(item)
    }

    // MARK: - Query
    public func reflectionSummary(for corpusId: String) async -> ReflectionSummaryResponse {
        let count = await typesense.reflectionCount(for: corpusId)
        return ReflectionSummaryResponse(message: "\(count) reflections")
    }

    public func historySummary(for corpusId: String) async -> HistorySummaryResponse {
        let count = await typesense.historyCount(for: corpusId)
        return HistorySummaryResponse(summary: "items: \(count)")
    }
}

