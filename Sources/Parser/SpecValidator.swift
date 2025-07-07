import Foundation

public enum SpecValidator {
    public struct ValidationError: Error, Equatable, CustomStringConvertible {
        public let message: String
        public var description: String { message }

        public init(_ message: String) {
            self.message = message
        }
    }

    public static func validate(_ spec: OpenAPISpec) throws {
        if spec.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError("title cannot be empty")
        }

        func validateSchema(_ schema: OpenAPISpec.Schema) throws {
            if let ref = schema.ref {
                let name = ref.components(separatedBy: "/").last ?? ref
                if spec.components?.schemas[name] == nil {
                    throw ValidationError("unresolved reference \(ref)")
                }
            }
            if let properties = schema.properties {
                for property in properties.values {
                    if let ref = property.ref {
                        let name = ref.components(separatedBy: "/").last ?? ref
                        if spec.components?.schemas[name] == nil {
                            throw ValidationError("unresolved reference \(ref)")
                        }
                    }
                }
            }
        }

        if let components = spec.components {
            for schema in components.schemas.values {
                try validateSchema(schema)
            }
        }

        if let paths = spec.paths {
            for (path, item) in paths {
                let operations = [item.get, item.post, item.put, item.delete].compactMap { $0 }
                for op in operations {
                    if op.operationId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        throw ValidationError("operationId cannot be empty for \(path)")
                    }

                    for param in op.parameters ?? [] {
                        if param.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            throw ValidationError("parameter name cannot be empty in \(op.operationId)")
                        }
                        if param.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            throw ValidationError("parameter location cannot be empty in \(param.name)")
                        }
                        if param.location == "path" && param.required != true {
                            throw ValidationError("path parameter \(param.name) must be required")
                        }
                        if let schema = param.schema {
                            try validateSchema(schema)
                        }
                    }

                    if let body = op.requestBody {
                        for media in body.content.values {
                            if let schema = media.schema {
                                try validateSchema(schema)
                            }
                        }
                    }

                    if let responses = op.responses {
                        for response in responses.values {
                            if let content = response.content {
                                for media in content.values {
                                    if let schema = media.schema {
                                        try validateSchema(schema)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
