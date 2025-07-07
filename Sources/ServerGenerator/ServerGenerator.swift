import Foundation
import Parser

public enum ServerGenerator {
    public static func emitServer(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        let output = "// Server kernel for \(spec.title)\n"
        try output.write(to: url.appendingPathComponent("Server.swift"), atomically: true, encoding: .utf8)
    }
}
