import Foundation
import Parser
import ModelEmitter
import ClientGenerator
import ServerGenerator

@main
struct GeneratorCLI {
    static func main() throws {
        var inputPath: String?
        var outputPath: String?
        var iterator = CommandLine.arguments.dropFirst().makeIterator()
        while let arg = iterator.next() {
            switch arg {
            case "--input": inputPath = iterator.next()
            case "--output": outputPath = iterator.next()
            default: break
            }
        }
        guard let inputPath, let outputPath else {
            print("Usage: generator --input <spec> --output <dir>")
            return
        }
        let specURL = URL(fileURLWithPath: inputPath)
        let outURL = URL(fileURLWithPath: outputPath)
        let spec = try SpecLoader.load(from: specURL)
        try FileManager.default.createDirectory(at: outURL, withIntermediateDirectories: true)
        try ModelEmitter.emit(from: spec, to: outURL)
        try ClientGenerator.emitClient(from: spec, to: outURL.appendingPathComponent("Client"))
        try ServerGenerator.emitServer(from: spec, to: outURL.appendingPathComponent("Server"))
    }
}
