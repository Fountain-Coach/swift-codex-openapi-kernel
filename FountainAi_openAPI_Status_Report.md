# FountainAI OpenAPI Implementation Status & Plan

## Current Status

This repository contains OpenAPI 3.1 specifications for seven FountainAI microservices under `FountainAi/openAPI/`.
Each spec has generated Swift sources for both a client SDK and a lightweight server kernel.
The generator is invoked via `regenerate.sh`, which iterates over every YAML spec and writes the output under `Generated/Client/<Service>` and `Generated/Server/<Service>`.

| Service | Version | Operations |
| --- | --- | --- |
| Baseline Awareness | v1 | 11 |
| Bootstrap | v1 | 6 |
| Function Caller | v1 | 5 |
| Persistence | v1 | 8 |
| Planner | v0 | 6 |
| LLM Gateway | v2 | 2 |
| Tools Factory | v1 | 4 |

Generated server code exposes stubs only—`Handlers` functions return empty `HTTPResponse` values—and the client SDK decodes responses as raw `Data`.
Unit tests verify the generator using a simplified fixture rather than the full FountainAI specs.

## Gaps to Production

1. **OpenAPI Coverage** – The parser understands only basic schemas and `operationId` fields. Parameters, request bodies, response types, and authentication are ignored.
2. **Typed Models** – Client requests always decode responses to `Data`. Server handlers lack typed input/output models.
3. **Runtime Server** – `HTTPKernel` does not include an actual HTTP networking layer, so generated servers cannot listen on a port or serve requests.
4. **Testing Depth** – Tests cover generator output but not service-specific contracts. There are no integration tests for the generated clients and servers.
5. **Documentation & Build Scripts** – Documentation explains how to regenerate code but does not describe how to run or deploy the servers.

## Implementation Plan for Production

### 1. Expand the OpenAPI Parser
- Parse path parameters, query parameters, and request bodies.
- Support response schemas and status codes.
- Validate required fields and reference resolution.

### 2. Enhance Model Emission
- Generate Swift types for request and response bodies.
- Support enums and array types.
- Emit shared models in a separate package so clients and servers can depend on them.

### 3. Upgrade Client Generator
- Produce request structs with typed `Body` and `Response` generics.
- Generate an `APIClient` that serializes request bodies and decodes typed responses.
- Provide convenience initializers for common authentication schemes (e.g. bearer tokens).

### 4. Upgrade Server Generator
- Emit a minimal HTTP server runtime using Swift Concurrency and `URLSession`’s `URLProtocol` or a simple socket listener.
- Populate handler stubs with typed request parameters and bodies.
- Generate error responses and status codes based on the spec.
- Allow dependency injection so production implementations can plug in custom logic.

### 5. Increase Test Coverage
- For each service spec, generate fixtures and golden files to assert models, requests, and routers compile correctly.
- Add integration tests that instantiate a generated server and call it via the generated client, verifying round‑trip serialization.

### 6. Continuous Integration & Deployment
- Configure GitHub Actions to run `swift build` and `swift test` on every pull request.
- Provide a Dockerfile for each server with minimal runtime dependencies.
- Document how to build and run a service container.

### 7. Documentation & Developer Experience
- Update `README.md` with step‑by‑step instructions for regenerating a single service, running its server, and using the client.
- Maintain a changelog of spec revisions and corresponding generated versions.

Implementing these steps will transform the current skeleton generators into production‑ready client libraries and standalone servers for the entire FountainAI suite.
