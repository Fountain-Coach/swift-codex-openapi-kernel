import Foundation

public struct OpenAPISpec: Codable {
    public struct Components: Codable {
        public var schemas: [String: Schema]
    }

    public struct Operation: Codable {
        public var operationId: String
    }

    public struct PathItem: Codable {
        public var get: Operation?
        public var post: Operation?
        public var put: Operation?
        public var delete: Operation?
    }

    public struct Schema: Codable {
        public struct Property: Codable {
            public var type: String?
        }

        public var type: String?
        public var properties: [String: Property]?
    }

    public let title: String
    public var components: Components?
    public var paths: [String: PathItem]?
}

extension OpenAPISpec.Schema.Property {
    public var swiftType: String {
        guard let type else { return "String" }
        switch type {
        case "string": return "String"
        case "integer": return "Int"
        case "boolean": return "Bool"
        default: return "String"
        }
    }
}
