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
├── FountainAi/openAPI/           ← Service specs grouped by version
│   ├── v0/                       ← Experimental APIs
│   ├── v1/                       ← Stable APIs
│   ├── v2/                       ← Next‑gen APIs
│   └── README.md                 ← Catalog of services and entrypoints
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

1. **Build the generator**
   ```bash
   swift build -c release
   ```
2. **Generate code for all FountainAI services**
   ```bash
   ./regenerate.sh
   ```
   This command reads every `*.yml` spec under `FountainAi/openAPI/*/` and
   emits a dedicated client and server for each service under
   `Generated/Client/<Service>/` and `Generated/Server/<Service>/`.
3. **Generate code for a single service**
   ```bash
   swift run generator --input FountainAi/openAPI/v1/bootstrap.yml --output Generated/tmp
   cp -r Generated/tmp/Client/. Generated/Client/bootstrap/
   cp -r Generated/tmp/Server/. Generated/Server/bootstrap/
   ```
   Replace `bootstrap.yml` with another spec to target a different service.
4. **Run the test suite**
   ```bash
   swift test
   ```

### Updating the spec

Add or modify any service spec under the appropriate version directory inside `FountainAi/openAPI/`. Re-run
`./regenerate.sh` whenever a spec changes to regenerate the Swift sources.

### Troubleshooting

- **Parser errors** – ensure each YAML file is valid OpenAPI 3.1. The generator prints the failing file path on error.
- **Missing Swift toolchain** – install dependencies with `sudo apt-get update && sudo apt-get install -y clang libicu-dev swift`.
- **Build failures** – run `swift build -v` to see compilation output and verify you generated sources for the intended service.

---

## ✅ Codex Compatibility

Everything in this repo is:
- Written and structured in Swift 6
- Built from scratch — no generators, no plugins
- Deterministically emitted
- Fully visible in Git
- Designed to be test-driven and Codex-readable

---

## 📦 Continuous Integration

The `.github/workflows/ci.yml` workflow builds the package and runs the tests on
every push and pull request using Swift 6.

---

## 🐳 Service Containers

Each generated server directory contains a `Dockerfile` that compiles the stub
server into a minimal container. To build and run the `baseline-awareness`
service:

```bash
cd Generated/Server/baseline-awareness
docker build -t baseline-awareness .
docker run --rm baseline-awareness
```

The container simply starts the Swift binary and prints a message. Networking is
not yet implemented.

---

## 📜 License

MIT License  
© 2025 FountainAI
