import Foundation

/// Dispatches registered functions by looking them up from the shared
/// TypesenseClient and performing a simple URLSession call.
struct FunctionDispatcher {
    enum DispatchError: Error { case notFound }

    let session: URLSession = .shared

    func invoke(functionId: String, payload: Data) async throws -> Data {
        guard let fn = TypesenseClient.shared.functionDetails(id: functionId) else {
            throw DispatchError.notFound
        }
        guard let url = URL(string: fn.httpPath) else {
            throw DispatchError.notFound
        }
        var req = URLRequest(url: url)
        req.httpMethod = fn.httpMethod
        req.httpBody = payload
        let (data, _) = try await session.data(for: req)
        return data
    }
}
