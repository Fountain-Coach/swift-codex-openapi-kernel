import Foundation
import Parser

public enum ModelEmitter {
    public static func emit(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

        var output = "// Models for \(spec.title)\n\n"

        if let schemas = spec.components?.schemas {
            for (name, schema) in schemas.sorted(by: { $0.key < $1.key }) {
                guard schema.type == "object", let properties = schema.properties else { continue }
                output += "public struct \(name): Codable {\n"
                for propName in properties.keys.sorted() {
                    if let property = properties[propName] {
                        output += "    public let \(propName): \(property.swiftType)\n"
                    }
                }
                output += "}\n\n"
            }
        }

        try output.write(to: url.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)

        let clientDir = url.appendingPathComponent("Client")
        try FileManager.default.createDirectory(at: clientDir, withIntermediateDirectories: true)
        try output.write(to: clientDir.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)

        let serverDir = url.appendingPathComponent("Server")
        try FileManager.default.createDirectory(at: serverDir, withIntermediateDirectories: true)
        try output.write(to: serverDir.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)
    }
}
