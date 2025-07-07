import Foundation

/// Minimal in-memory representation of a Typesense service used for testing.
/// This allows the Persistence and Function Caller services to share state
/// without requiring an external dependency.
public actor TypesenseClient {
    public static let shared = TypesenseClient()

    private var corpora: Set<String> = []
    private var functions: [String: Function] = [:]
    private var baselines: [String: [String: Baseline]] = [:]
    private var drifts: [String: [String: Drift]] = [:]
    private var patterns: [String: [String: Patterns]] = [:]
    private var reflections: [String: [String: Reflection]] = [:]

    private init() {}

    // MARK: - Corpora
    public func createCorpus(id: String) -> CorpusResponse {
        corpora.insert(id)
        return CorpusResponse(corpusId: id, message: "created")
    }

    public func listCorpora() -> [String] {
        return Array(corpora)
    }

    // MARK: - Functions
    public func addFunction(_ fn: Function) {
        functions[fn.functionId] = fn
    }

    public func listFunctions() -> [Function] {
        return Array(functions.values)
    }

    public func functionDetails(id: String) -> Function? {
        return functions[id]
    }

    // MARK: - Baseline Data
    public func addBaseline(_ baseline: Baseline) {
        var items = baselines[baseline.corpusId] ?? [:]
        items[baseline.baselineId] = baseline
        baselines[baseline.corpusId] = items
    }

    public func addDrift(_ drift: Drift) {
        var items = drifts[drift.corpusId] ?? [:]
        items[drift.driftId] = drift
        drifts[drift.corpusId] = items
    }

    public func addPatterns(_ patternsReq: Patterns) {
        var items = patterns[patternsReq.corpusId] ?? [:]
        items[patternsReq.patternsId] = patternsReq
        patterns[patternsReq.corpusId] = items
    }

    public func addReflection(_ reflection: Reflection) {
        var items = reflections[reflection.corpusId] ?? [:]
        items[reflection.reflectionId] = reflection
        reflections[reflection.corpusId] = items
    }

    public func reflectionCount(for corpusId: String) -> Int {
        return reflections[corpusId]?.count ?? 0
    }

    public func historyCount(for corpusId: String) -> Int {
        let b = baselines[corpusId]?.count ?? 0
        let d = drifts[corpusId]?.count ?? 0
        let p = patterns[corpusId]?.count ?? 0
        let r = reflections[corpusId]?.count ?? 0
        return b + d + p + r
    }
}
