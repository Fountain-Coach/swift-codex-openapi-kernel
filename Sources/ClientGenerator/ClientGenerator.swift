import Foundation
import Parser

public enum ClientGenerator {
    public static func emitClient(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        let output = "// Client SDK for \(spec.title)\n"
        try output.write(to: url.appendingPathComponent("Client.swift"), atomically: true, encoding: .utf8)
    }
}
