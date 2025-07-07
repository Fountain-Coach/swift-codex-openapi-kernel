import XCTest
@testable import Generator

final class GeneratorTests: XCTestCase {
    func testCLIWithFixtures() throws {
        let fixturesDir = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
        let specURL = fixturesDir.appendingPathComponent("api.json")
        let outDir = FileManager.default.temporaryDirectory.appendingPathComponent("cli-test")
        try? FileManager.default.removeItem(at: outDir)
        try FileManager.default.createDirectory(at: outDir, withIntermediateDirectories: true)

        try GeneratorCLI.run(args: ["--input", specURL.path, "--output", outDir.path])

        func assertFile(_ relative: String, fixtureName: String? = nil) throws {
            let generatedURL = outDir.appendingPathComponent(relative)
            let fixtureURL = fixturesDir
                .appendingPathComponent("Generated")
                .appendingPathComponent(fixtureName ?? relative)
            let generated = try String(contentsOf: generatedURL)
            let expected = try String(contentsOf: fixtureURL)
            XCTAssertEqual(generated, expected, "Mismatch for \(relative)")
        }

        try assertFile("Models.swift", fixtureName: "RootModels.swift")
        try assertFile("Client/APIRequest.swift")
        try assertFile("Client/APIClient.swift")
        try assertFile("Client/Models.swift", fixtureName: "Client/ClientModels.swift")
        try assertFile("Client/Requests/GetTodos.swift")
        try assertFile("Server/HTTPRequest.swift")
        try assertFile("Server/HTTPResponse.swift")
        try assertFile("Server/HTTPServer.swift")
        try assertFile("Server/Handlers.swift")
        try assertFile("Server/Router.swift")
        try assertFile("Server/HTTPKernel.swift")
        try assertFile("Server/Models.swift", fixtureName: "Server/ServerModels.swift")
    }
}
