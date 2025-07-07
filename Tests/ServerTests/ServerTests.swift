import XCTest
@testable import Parser
@testable import ServerGenerator

final class ServerTests: XCTestCase {
    func testServerFilesGenerated() throws {
        let json = """
        {
          "title": "Sample API",
          "paths": {
            "/todos": { "get": { "operationId": "get_todos" } }
          }
        }
        """
        let specURL = FileManager.default.temporaryDirectory.appendingPathComponent("spec.json")
        try json.write(to: specURL, atomically: true, encoding: .utf8)
        let spec = try SpecLoader.load(from: specURL)

        let outDir = FileManager.default.temporaryDirectory.appendingPathComponent("server")
        try? FileManager.default.removeItem(at: outDir)
        try ServerGenerator.emitServer(from: spec, to: outDir)

        XCTAssertTrue(FileManager.default.fileExists(atPath: outDir.appendingPathComponent("HTTPRequest.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: outDir.appendingPathComponent("HTTPResponse.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: outDir.appendingPathComponent("Handlers.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: outDir.appendingPathComponent("Router.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: outDir.appendingPathComponent("HTTPKernel.swift").path))
    }
}
