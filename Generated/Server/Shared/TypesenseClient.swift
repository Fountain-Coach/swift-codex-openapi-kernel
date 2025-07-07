import Foundation

/// Minimal in-memory representation of a Typesense service used for testing.
/// This allows the Persistence and Function Caller services to share state
/// without requiring an external dependency.
public actor TypesenseClient {
    public static let shared = TypesenseClient()

    private var corpora: Set<String> = []
    private var functions: [String: Function] = [:]

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
}
