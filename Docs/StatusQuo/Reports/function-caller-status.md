# Function Caller Service – Implementation Status

## Overview
The Function Caller maps OpenAI function-calling plans to HTTP operations using definitions from the Tools Factory.
Spec path: `FountainAi/openAPI/v1/function-caller.yml` (version 1.0.0).

## Implementation State
- OpenAPI operations defined: 3
- Generated client SDK at `Generated/Client/function-caller`
- Generated server kernel at `Generated/Server/function-caller`
- Handler stubs perform no invocation logic
- Client uses untyped `Data` decoding
- No dedicated tests for this service

## Next Steps toward Production
- Implement dynamic function dispatch sourced from the Tools Factory
- Generate typed models for request bodies and responses
- Expand integration tests to cover registered tool execution
- Add authentication and error handling
