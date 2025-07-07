import Foundation
import Yams


public enum SpecLoader {
    public static func load(from url: URL) throws -> OpenAPISpec {
        let data = try Data(contentsOf: url)

        // Attempt JSON decoding first
        if let spec = try? JSONDecoder().decode(OpenAPISpec.self, from: data) {
            try SpecValidator.validate(spec)
            return spec
        }

        // Fallback to YAML decoding
        guard let yamlString = String(data: data, encoding: .utf8) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Input data is not valid UTF-8"))
        }
        let yamlObject = try Yams.load(yaml: yamlString)
        let jsonData = try JSONSerialization.data(withJSONObject: yamlObject, options: [])
        let spec = try JSONDecoder().decode(OpenAPISpec.self, from: jsonData)
        try SpecValidator.validate(spec)
        return spec
    }
}
