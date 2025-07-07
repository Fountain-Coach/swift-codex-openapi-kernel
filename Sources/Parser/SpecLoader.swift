import Foundation

public struct OpenAPISpec: Codable {
    public let title: String
}

public enum SpecLoader {
    public static func load(from url: URL) throws -> OpenAPISpec {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(OpenAPISpec.self, from: data)
    }
}
