import Foundation

public struct OpenAPISpec: Codable {
    /// Components container supporting only schemas for now.
    public struct Components: Codable {
        public var schemas: [String: Schema]
    }

    /// Basic JSON Schema representation used throughout the spec.
    public struct Schema: Codable {
        public struct Property: Codable {
            public var ref: String?
            public var type: String?

            enum CodingKeys: String, CodingKey {
                case ref = "$ref"
                case type
            }
        }

        public var ref: String?
        public var type: String?
        public var properties: [String: Property]?

        enum CodingKeys: String, CodingKey {
            case ref = "$ref"
            case type
            case properties
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
        default: return "String"
        }
    }
}
