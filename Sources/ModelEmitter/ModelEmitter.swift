import Foundation
import Parser

public enum ModelEmitter {
    public static func emit(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        let output = "// Models for \(spec.title)\n"
        try output.write(to: url.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)
    }
}
