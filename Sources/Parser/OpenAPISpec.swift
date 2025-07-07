import Foundation

public struct OpenAPISpec: Codable {
    /// Components container supporting only schemas for now.
    public struct Components: Codable {
        public var schemas: [String: Schema]
    }

    /// Basic JSON Schema representation used throughout the spec.
    public final class Schema: Codable {
        public final class Property: Codable {
            public var ref: String?
            public var type: String?
            public var enumValues: [String]?
            public var items: Schema?

            enum CodingKeys: String, CodingKey {
                case ref = "$ref"
                case type
                case enumValues = "enum"
                case items
            }
        }

        public var ref: String?
        public var type: String?
        public var properties: [String: Property]?
        public var enumValues: [String]?
        public var items: Schema?

        enum CodingKeys: String, CodingKey {
            case ref = "$ref"
            case type
            case properties
            case enumValues = "enum"
            case items
        }
    }

    /// Parameter object representing path or query parameters.
    public struct Parameter: Codable {
        public var name: String
        public var location: String
        public var required: Bool?
        public var schema: Schema?

        enum CodingKeys: String, CodingKey {
            case name
            case location = "in"
            case required
            case schema
        }
    }

    /// Media type containing a schema.
    public struct MediaType: Codable {
        public var schema: Schema?
    }

    /// Request body container.
    public struct RequestBody: Codable {
        public var content: [String: MediaType]
    }

    /// Response object keyed by status code.
    public struct Response: Codable {
        public var description: String?
        public var content: [String: MediaType]?
    }

    /// Operation including parameters, request body and responses.
    public struct Operation: Codable {
        public var operationId: String
        public var parameters: [Parameter]?
        public var requestBody: RequestBody?
        public var responses: [String: Response]?
    }

    /// Path item grouping multiple HTTP methods.
    public struct PathItem: Codable {
        public var get: Operation?
        public var post: Operation?
        public var put: Operation?
        public var delete: Operation?
    }

    public let title: String
    public var components: Components?
    public var paths: [String: PathItem]?
}

extension OpenAPISpec.Schema.Property {
    public var swiftType: String {
        if let ref {
            return ref.components(separatedBy: "/").last ?? ref
        }
        guard let type else { return "String" }
        switch type {
        case "string": return "String"
        case "integer": return "Int"
        case "boolean": return "Bool"
        case "array":
            if let itemType = items?.swiftType {
                return "[\(itemType)]"
            } else {
                return "[String]"
            }
        default: return "String"
        }
    }
}

extension OpenAPISpec.Schema {
    public var swiftType: String {
        if let ref {
            return ref.components(separatedBy: "/").last ?? ref
        }
        guard let type else { return "String" }
        switch type {
        case "string": return "String"
        case "integer": return "Int"
        case "boolean": return "Bool"
        case "array":
            if let itemType = items?.swiftType {
                return "[\(itemType)]"
            } else {
                return "[String]"
            }
        default: return "String"
        }
    }
}

extension OpenAPISpec.Parameter {
    /// Swift identifier-safe name for the parameter.
    public var swiftName: String {
        name.replacingOccurrences(of: "-", with: "_")
    }

    /// Swift type inferred from the associated schema, defaulting to `String`.
    public var swiftType: String {
        schema?.swiftType ?? "String"
    }
}
