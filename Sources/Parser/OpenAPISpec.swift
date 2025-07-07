import Foundation

public struct OpenAPISpec: Codable {
    public struct Components: Codable {
        public var schemas: [String: Schema]
    }

    public struct Schema: Codable {
        public struct Property: Codable {
            public var type: String
        }

        public var type: String
        public var properties: [String: Property]?
    }

    public let title: String
    public var components: Components?
}

extension OpenAPISpec.Schema.Property {
    public var swiftType: String {
        switch type {
        case "string": return "String"
        case "integer": return "Int"
        case "boolean": return "Bool"
        default: return "String"
        }
    }
}
