import Foundation

/// Minimal in-memory representation of a Typesense service used for testing.
/// This allows the Persistence and Function Caller services to share state
/// without requiring an external dependency.
final class TypesenseClient {
    static let shared = TypesenseClient()

    private var corpora: Set<String> = []
    private var functions: [String: Function] = [:]
    private let lock = NSLock()

    private init() {}

    // MARK: - Corpora
    func createCorpus(id: String) -> CorpusResponse {
        lock.lock(); defer { lock.unlock() }
        corpora.insert(id)
        return CorpusResponse(corpusId: id, message: "created")
    }

    func listCorpora() -> [String] {
        lock.lock(); defer { lock.unlock() }
        return Array(corpora)
    }

    // MARK: - Functions
    func addFunction(_ fn: Function) {
        lock.lock(); defer { lock.unlock() }
        functions[fn.functionId] = fn
    }

    func listFunctions() -> [Function] {
        lock.lock(); defer { lock.unlock() }
        return Array(functions.values)
    }

    func functionDetails(id: String) -> Function? {
        lock.lock(); defer { lock.unlock() }
        return functions[id]
    }
}
