# Cross-Platform Integration Testing Approach

This document describes the cross-platform runtime now used for integration testing. Generated clients and servers compile and run on both Linux and macOS using `AsyncHTTPClient` and `swift-nio`.

## Use `AsyncHTTPClient`

- Adopt [`AsyncHTTPClient`](https://github.com/swift-server/async-http-client) from the Swift Server workgroup.
- It is open source, pure Swift and builds on `swift-nio`, so it runs the same on Linux and macOS.
- Provides async `get`, `post` and streaming APIs that work with Swift's structured concurrency.

## API Client Changes

1. Introduce a protocol `HTTPClientProtocol` with an async `execute` method returning `(ByteBuffer, HTTPHeaders)`.
2. Implement a default client using `AsyncHTTPClient`.
3. Keep a small `URLSession` wrapper for platforms where Foundation is preferred.
4. Generated clients depend only on the protocol, so tests can inject either implementation.

## Server Runtime

- Build a minimal HTTP server using `swift-nio`'s `HTTPServer`.
- Existing `HTTPKernel` can remain unchanged; the NIO server simply converts incoming requests into the generated `HTTPRequest` and forwards them.
- This server works identically on Linux and macOS and introduces no vendor lock‑in.

## Integration Tests

- Launch the NIO server in the test process on a random local port.
- Use the `AsyncHTTPClient` implementation of the generated SDK to make requests.
- Verify round‑trip behavior between the generated server and client.

## Benefits

- **Cross‑platform**: works the same on Swift's open Linux toolchains and macOS.
- **Vendor neutral**: relies only on the open Swift Server libraries, not proprietary APIs.
- **Async by default**: both client and server use structured concurrency, so tests and production code share the same async foundation.
- **Composable**: the protocol allows swapping in different HTTP backends as needed.

This approach keeps the project fully open while enabling the integration tests called for in the [Next Steps](next-steps.md) report.
