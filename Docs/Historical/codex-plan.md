# Codex Execution Plan: swift-codex-openapi-kernel

This plan defines how Codex should build a Swift 6-native OpenAPI code generator that emits both client SDKs and a standalone HTTP server kernel — with no external dependencies.

---

## 🪪 Phase 0 · Repository Identity

- [x] Create `agent.swift` to describe Codex orchestration behavior.
- [x] Create `.codex` manifest to document structure, triggers, CLI, and test commands.

---

## 🧱 Phase 1 · Project Scaffolding

- [x] Initialize SwiftPM layout.
- [x] Define CLI product in `Package.swift`.
- [x] Add `Sources/Generator/` and `Tests/GeneratorTests/`.
- [x] Create a minimal `OpenAPI/api.yaml` input spec.

---

## 📜 Phase 2 · OpenAPI 3.1 Parser

- [x] Create `OpenAPISpec.swift` (spec structs).
- [ ] Implement `SpecLoader.swift` (currently JSON only; add YAML support).
- [x] Add tests for spec parsing and validation.

---

## 🧬 Phase 3 · Model Emitter

- [x] Generate `Codable` models from `components.schemas`.
- [x] Emit `Models.swift` into both `Client/` and `Server/`.
- [x] Add golden file tests.

---

## 🔌 Phase 4 · Client SDK Generator

- [x] Generate `APIRequest.swift` and `APIClient.swift`.
- [x] Emit typed requests (e.g. `GetTodo.swift`).
- [x] Group by tag or path structure.
- [x] Test requests with mockable inputs.

---

## 🌀 Phase 5 · Native HTTP Server Generator

- [x] Emit `HTTPRequest.swift` and `HTTPResponse.swift`.
- [x] Build `Router.swift` that statically dispatches by method + path.
- [x] Emit `Handlers.swift` with stubs for each route.
- [x] Implement `HTTPKernel.swift` to launch the server.

---

## 🧪 Phase 6 · Testing & Validation

- [x] Add `XCTestCase` tests for model parsing.
- [x] Test the CLI with fixtures.
- [x] Simulate HTTP requests directly to router/kernel in unit tests.

---

## 📦 Phase 7 · Documentation & Developer Experience

- [ ] Ensure `README.md` is accurate and actionable.
- [ ] Add usage samples and examples.
- [ ] Consider GitHub Actions workflow for `swift build` + `swift test`.

---
