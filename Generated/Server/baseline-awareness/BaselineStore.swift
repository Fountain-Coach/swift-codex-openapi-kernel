import Foundation

/// In-memory store used by the Baseline Awareness service during tests.
public actor BaselineStore {
    public static let shared = BaselineStore()

    struct Corpus {
        var baselines: [String: String] = [:]
        var drifts: [String: String] = [:]
        var patterns: [String: String] = [:]
        var reflections: [String: ReflectionRequest] = [:]
    }

    private var corpora: [String: Corpus] = [:]
    private init() {}

    // MARK: - Corpus Management
    public func createCorpus(id: String) -> InitOut {
        if corpora[id] == nil {
            corpora[id] = Corpus()
        }
        return InitOut(message: "created")
    }

    // MARK: - Baseline Data
    public func addBaseline(_ baseline: BaselineRequest) {
        var corpus = corpora[baseline.corpusId] ?? Corpus()
        corpus.baselines[baseline.baselineId] = baseline.content
        corpora[baseline.corpusId] = corpus
    }

    public func addDrift(_ drift: DriftRequest) {
        var corpus = corpora[drift.corpusId] ?? Corpus()
        corpus.drifts[drift.driftId] = drift.content
        corpora[drift.corpusId] = corpus
    }

    public func addPatterns(_ patternsReq: PatternsRequest) {
        var corpus = corpora[patternsReq.corpusId] ?? Corpus()
        corpus.patterns[patternsReq.patternsId] = patternsReq.content
        corpora[patternsReq.corpusId] = corpus
    }

    public func addReflection(_ reflection: ReflectionRequest) {
        var corpus = corpora[reflection.corpusId] ?? Corpus()
        corpus.reflections[reflection.reflectionId] = reflection
        corpora[reflection.corpusId] = corpus
    }

    // MARK: - Query
    public func reflectionSummary(for corpusId: String) -> ReflectionSummaryResponse {
        let count = corpora[corpusId]?.reflections.count ?? 0
        return ReflectionSummaryResponse(message: "\(count) reflections")
    }

    public func historySummary(for corpusId: String) -> HistorySummaryResponse {
        let corpus = corpora[corpusId] ?? Corpus()
        let count = corpus.baselines.count + corpus.drifts.count + corpus.patterns.count + corpus.reflections.count
        return HistorySummaryResponse(summary: "items: \(count)")
    }
}

