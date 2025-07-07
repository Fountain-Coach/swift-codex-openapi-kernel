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
    }
}
