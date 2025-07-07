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

    func testOperationParsesParametersAndResponses() throws {
        let json = """
        {
          "title": "API",
          "components": {
            "schemas": {
              "Todo": {"type": "object"}
            }
          },
          "paths": {
            "/todos/{id}": {
              "get": {
                "operationId": "get_todo",
                "parameters": [
                  {"name": "id", "in": "path", "required": true, "schema": {"type": "string"}},
                  {"name": "verbose", "in": "query", "schema": {"type": "boolean"}}
                ],
                "responses": {
                  "200": {
                    "description": "ok",
                    "content": {"application/json": {"schema": {"$ref": "#/components/schemas/Todo"}}}
                  }
                }
              }
            }
          }
        }
        """

        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent("spec.json")
        try json.write(to: tmp, atomically: true, encoding: .utf8)
        let spec = try SpecLoader.load(from: tmp)
        let op = spec.paths?["/todos/{id}"]?.get
        XCTAssertEqual(op?.parameters?.count, 2)
        XCTAssertEqual(op?.responses?["200"]?.content?["application/json"]?.schema?.ref, "#/components/schemas/Todo")
    }

    func testValidationRejectsUnresolvedReference() throws {
        let json = """
        {
          "title": "Bad API",
          "paths": {
            "/items": {
              "get": {
                "operationId": "list",
                "responses": {"200": {"content": {"application/json": {"schema": {"$ref": "#/components/schemas/Missing"}}}}}
              }
            }
          }
        }
        """

        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent("bad.json")
        try json.write(to: tmp, atomically: true, encoding: .utf8)
        XCTAssertThrowsError(try SpecLoader.load(from: tmp)) { error in
            guard let validationError = error as? SpecValidator.ValidationError else { return XCTFail("wrong error") }
            XCTAssertEqual(validationError, SpecValidator.ValidationError("unresolved reference #/components/schemas/Missing"))
        }
    }
}
