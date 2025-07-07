import XCTest
@testable import Parser
@testable import ModelEmitter

final class ModelEmitterTests: XCTestCase {
    func testModelEmissionMatchesGoldenFile() throws {
        let specData = """
        {
          "title": "Sample API",
          "components": {
            "schemas": {
              "Todo": {
                "type": "object",
                "properties": {
                  "id": { "type": "integer" },
                  "name": { "type": "string" }
                }
              }
            }
          }
        }
        """.data(using: .utf8)!

        let specURL = FileManager.default.temporaryDirectory.appendingPathComponent("spec.json")
        try specData.write(to: specURL)
        let spec = try SpecLoader.load(from: specURL)

        let outDir = FileManager.default.temporaryDirectory.appendingPathComponent("out")
        try? FileManager.default.removeItem(at: outDir)
        try ModelEmitter.emit(from: spec, to: outDir)

        let generatedURL = outDir.appendingPathComponent("Models.swift")
        let generated = try String(contentsOf: generatedURL)

        let fixtureURL = Bundle.module.url(forResource: "Models", withExtension: "swift")!
        let expected = try String(contentsOf: fixtureURL)

        XCTAssertEqual(generated, expected)
    }
}

