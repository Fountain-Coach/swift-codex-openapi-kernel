import Foundation

public actor PrometheusAdapter {
    public static let shared = PrometheusAdapter()

    private var counters: [String:Int] = [:]

    public init() {}

    private func key(service: String, path: String) -> String {
        "requests_total{service=\"\(service)\",path=\"\(path)\"}"
    }

    public func record(service: String, path: String) {
        let k = key(service: service, path: path)
        counters[k, default: 0] += 1
    }

    public func exposition() -> String {
        let lines = counters.map { "\($0.key) \($0.value)" }.sorted().joined(separator: "\n")
        return lines + "\n"
    }
}
