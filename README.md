# swift-codex-openapi-kernel

*A fully Codex-compatible Swift 6 tool that generates both client SDKs and native HTTP server kernels from OpenAPI 3.1 — with zero dependencies on external frameworks like Vapor.*

---

## 🎯 Purpose

This repository implements a complete code generation workflow that:
- Parses OpenAPI 3.1 specs
- Emits fully typed Swift client SDKs
- Emits native Swift HTTP server kernels — no Vapor, no plugins, no hidden logic
- Ensures all generated code is deterministic, committed, and Codex-orchestratable

---

## ✨ What It Generates

### ✅ Client SDK
- `Codable` models
- Typed request structs per operation
- A configurable `APIClient` using `URLSession`
- Request/response validation via HTTP status codes

### ✅ Native HTTP Server
- Static router table from OpenAPI paths
- `HTTPRequest`/`HTTPResponse` types
- Route handler stubs
- Pluggable boot logic to launch an async Swift-based HTTP kernel
- Fully testable with standard `XCTest`

---

## 📁 Repository Structure

```
swift-codex-openapi-kernel/
├── OpenAPI/
│   └── api.yaml                  ← Input OpenAPI 3.1 specification
├── Sources/
│   └── Generator/                ← CLI tool source
├── Generated/
│   ├── Client/                   ← Client SDK output
│   └── Server/                   ← Native server output
├── Tests/
│   ├── GeneratorTests/
│   └── ServerTests/
├── codex-plan.md
├── README.md
└── .codex
```

---

## 🚀 Getting Started

```bash
swift build -c release
./regenerate.sh
swift test
```

---

## ✅ Codex Compatibility

Everything in this repo is:
- Written and structured in Swift 6
- Built from scratch — no generators, no plugins
- Deterministically emitted
- Fully visible in Git
- Designed to be test-driven and Codex-readable

---

## 📜 License

MIT License  
© 2025 FountainAI
