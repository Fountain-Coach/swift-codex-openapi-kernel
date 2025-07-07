import Foundation
import Parser

public enum ModelEmitter {
    public static func emit(from spec: OpenAPISpec, to url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

        var output = "// Models for \(spec.title)\n\n"

        func appendSchema(_ name: String, _ schema: OpenAPISpec.Schema) {
            if let enumValues = schema.enumValues, schema.type == "string" {
                output += "public enum \(name): String, Codable {\n"
                for value in enumValues {
                    output += "    case \(value)\n"
                }
                output += "}\n\n"
                return
            }

            if schema.type == "object", let properties = schema.properties {
                output += "public struct \(name): Codable {\n"
                for prop in properties.keys.sorted() {
                    if let property = properties[prop] {
                        output += "    public let \(prop): \(property.swiftType)\n"
                    }
                }
                output += "}\n\n"
                return
            }

            if schema.type == "array", let items = schema.items {
                output += "public typealias \(name) = [\(items.swiftType)]\n\n"
                return
            }

            if let type = schema.type {
                output += "public typealias \(name) = \(schema.swiftType)\n\n"
            }
        }

        if let schemas = spec.components?.schemas {
            for (name, schema) in schemas.sorted(by: { $0.key < $1.key }) {
                appendSchema(name, schema)
            }
        }

        if let paths = spec.paths {
            for (_, item) in paths {
                let ops = [item.get, item.post, item.put, item.delete].compactMap { $0 }
                for op in ops {
                    if let reqSchema = op.requestBody?.content["application/json"]?.schema, reqSchema.ref == nil {
                        appendSchema("\(op.operationId)Request", reqSchema)
                    }
                    if let respSchema = op.responses?["200"]?.content?["application/json"]?.schema, respSchema.ref == nil {
                        appendSchema("\(op.operationId)Response", respSchema)
                    }
                }
            }
        }

        try output.write(to: url.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)

        let clientDir = url.appendingPathComponent("Client")
        try FileManager.default.createDirectory(at: clientDir, withIntermediateDirectories: true)
        try output.write(to: clientDir.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)

        let serverDir = url.appendingPathComponent("Server")
        try FileManager.default.createDirectory(at: serverDir, withIntermediateDirectories: true)
        try output.write(to: serverDir.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)

        let packageDir = url.appendingPathComponent("SharedModels")
        let sourcesDir = packageDir.appendingPathComponent("Sources/SharedModels")
        try FileManager.default.createDirectory(at: sourcesDir, withIntermediateDirectories: true)
        try output.write(to: sourcesDir.appendingPathComponent("Models.swift"), atomically: true, encoding: .utf8)

        let packageSwift = """
        // swift-tools-version: 6.1
        import PackageDescription

        let package = Package(
            name: \"SharedModels\",
            products: [
                .library(name: \"SharedModels\", targets: [\"SharedModels\"])
            ],
            targets: [
                .target(name: \"SharedModels\")
            ]
        )
        """
        try packageSwift.write(to: packageDir.appendingPathComponent("Package.swift"), atomically: true, encoding: .utf8)
    }
}
