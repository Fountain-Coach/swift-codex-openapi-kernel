import XCTest
@testable import Parser

final class ParserTests: XCTestCase {
    func testSpecLoaderParsesTitle() throws {
        let json = "{\"title\": \"My API\"}"
        let tmpDir = FileManager.default.temporaryDirectory
        let fileURL = tmpDir.appendingPathComponent("spec.json")
        try json.write(to: fileURL, atomically: true, encoding: .utf8)

        let spec = try SpecLoader.load(from: fileURL)
        XCTAssertEqual(spec.title, "My API")
    }

    func testSpecLoaderParsesYAMLTitle() throws {
        let yaml = "title: My API"
        let tmpDir = FileManager.default.temporaryDirectory
        let fileURL = tmpDir.appendingPathComponent("spec.yaml")
        try yaml.write(to: fileURL, atomically: true, encoding: .utf8)

        let spec = try SpecLoader.load(from: fileURL)
        XCTAssertEqual(spec.title, "My API")
    }

    func testSpecLoaderParsesInfoTitle() throws {
        let yaml = """
        openapi: 3.1.0
        info:
          title: Fancy API
        paths: {}
        """
        let tmpDir = FileManager.default.temporaryDirectory
        let fileURL = tmpDir.appendingPathComponent("spec-info.yaml")
        try yaml.write(to: fileURL, atomically: true, encoding: .utf8)

        let spec = try SpecLoader.load(from: fileURL)
        XCTAssertEqual(spec.title, "Fancy API")
    }

    func testSpecValidationRejectsEmptyTitle() throws {
        let spec = OpenAPISpec(title: "")
        XCTAssertThrowsError(try SpecValidator.validate(spec)) { error in
            guard let validationError = error as? SpecValidator.ValidationError else {
                return XCTFail("Unexpected error type")
            }
            XCTAssertEqual(validationError, SpecValidator.ValidationError("title cannot be empty"))
        }
    }
}
