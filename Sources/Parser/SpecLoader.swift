import Foundation


public enum SpecLoader {
    public static func load(from url: URL) throws -> OpenAPISpec {
        let data = try Data(contentsOf: url)
        let spec = try JSONDecoder().decode(OpenAPISpec.self, from: data)
        try SpecValidator.validate(spec)
        return spec
    }
}
