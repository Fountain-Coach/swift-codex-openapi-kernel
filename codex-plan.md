# Codex Execution Plan: swift-codex-openapi-kernel

This plan defines how Codex should build a Swift 6-native OpenAPI code generator that emits both client SDKs and a standalone HTTP server kernel — with no external dependencies.

---

## 🪪 Phase 0 · Repository Identity

- [ ] Create `agent.swift` to describe Codex orchestration behavior.
- [ ] Create `.codex` manifest to document structure, triggers, CLI, and test commands.

---

## 🧱 Phase 1 · Project Scaffolding

- [ ] Initialize SwiftPM layout.
- [ ] Define CLI product in `Package.swift`.
- [ ] Add `Sources/Generator/` and `Tests/GeneratorTests/`.
- [ ] Create a minimal `OpenAPI/api.yaml` input spec.

---

## 📜 Phase 2 · OpenAPI 3.1 Parser

- [ ] Create `OpenAPISpec.swift` (spec structs).
- [ ] Implement `SpecLoader.swift` (loads YAML or JSON).
- [ ] Add tests for spec parsing and validation.

---

## 🧬 Phase 3 · Model Emitter

- [ ] Generate `Codable` models from `components.schemas`.
- [ ] Emit `Models.swift` into both `Client/` and `Server/`.
- [ ] Add golden file tests.

---

## 🔌 Phase 4 · Client SDK Generator

- [ ] Generate `APIRequest.swift` and `APIClient.swift`.
- [ ] Emit typed requests (e.g. `GetTodo.swift`).
- [ ] Group by tag or path structure.
- [ ] Test requests with mockable inputs.

---

## 🌀 Phase 5 · Native HTTP Server Generator

- [ ] Emit `HTTPRequest.swift` and `HTTPResponse.swift`.
- [ ] Build `Router.swift` that statically dispatches by method + path.
- [ ] Emit `Handlers.swift` with stubs for each route.
- [ ] Implement `HTTPKernel.swift` to launch the server.

---

## 🧪 Phase 6 · Testing & Validation

- [ ] Add `XCTestCase` tests for model parsing.
- [ ] Test the CLI with fixtures.
- [ ] Simulate HTTP requests directly to router/kernel in unit tests.

---

## 📦 Phase 7 · Documentation & Developer Experience

- [ ] Ensure `README.md` is accurate and actionable.
- [ ] Add usage samples and examples.
- [ ] Consider GitHub Actions workflow for `swift build` + `swift test`.

---
