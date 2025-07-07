You are Codex. You are now inside the repository `swift-codex-openapi-kernel`.

The `README.md` describes the purpose and structure of this project. The `.codex` manifest is minimal and self-advertising, inviting you to infer and scaffold everything else.

## Task

1. Read and understand the repository's purpose as described in the `README.md`.
2. Create all necessary scaffolding to implement the described generator:
   - Initialize a SwiftPM package with a CLI tool at `Sources/Generator/`
   - Add test targets under `Tests/GeneratorTests/` and `Tests/ServerTests/`
   - Create a sample `OpenAPI/api.yaml` file as input
3. Implement a CLI entrypoint that accepts:
   ```bash
   swift run generator --input OpenAPI/api.yaml --output Generated/
   ```
4. Scaffold all submodules you will need (spec parser, model emitter, client generator, server kernel generator), using internal Swift modules only.

## Constraints

- You must use only Swift 6.
- You may use Foundation and Codable.
- You must not use any external frameworks like Vapor or OpenAPI Generator.
- All output Swift files must be committed and readable by Codex.
- Your generator must be testable via `swift test`.

## Notes

- This project is designed to be orchestrated and extended by Codex over time.
- All emitted code must be deterministic, committed, and testable.
- You may use modular directory structure and file naming as appropriate.

Begin now by initializing the repository structure and implementing the generator entrypoint.
