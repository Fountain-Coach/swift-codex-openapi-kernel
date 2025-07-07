# FountainAi Implementation Agenda

This agenda outlines the steps to implement and document FountainAI's services and clients using the OpenAPI definitions under `FountainAi/openAPI/<version>/`. The goal is to evolve from the simple demonstration spec located at `OpenAPI/api.yaml` to a fully generated set of Swift servers and client SDKs for all FountainAI services.

## 1. Start from the Simplified Spec

1. **Generate baseline code** using `OpenAPI/api.yaml`.
   - Run `./regenerate.sh` to produce the initial client and server under `Generated/`.
   - Verify the generated sources compile and tests pass.
   - **Status:** Completed in the current repository. The baseline client and server are present under `Generated/` and all tests succeed.
2. **Document the workflow** in `README.md`.
   - Provide a concise walkthrough explaining how the generator reads the spec and outputs Swift code.
   - Include the command line arguments and expected directory layout.

## 2. Introduce FountainAI Service APIs

Each service has its own OpenAPI file in `FountainAi/openAPI/<version>/`:

- `v1/baseline-awareness.yml` – manages baselines, drift, reflection data, and analytics.
- `v1/bootstrap.yml` – initializes corpora and seeds default roles.
- `v1/function-caller.yml` – maps OpenAI function-calling plans to HTTP operations.
- `v1/persist.yml` – persistence and semantic indexing via Typesense.
- `v0/planner.yml` – orchestrates planning workflows for the LLM.
- `v2/llm-gateway.yml` – proxies requests to any LLM with function-calling support.
- `v1/tools-factory.yml` – registers and manages tool definitions.

For each service:

1. **Generate Swift models and handlers** using the appropriate YAML file.
2. **Emit a dedicated client SDK** so other services or external consumers can call it.
3. **Commit the generated sources** under `Generated/Client/<Service>/` and `Generated/Server/<Service>/`.
4. **Write basic unit tests** that instantiate the router and verify a sample route (e.g., health or metrics) responds correctly.

## 3. Consolidate Documentation

1. **Create a master OpenAPI catalog** summarizing all available services and entrypoints.
   - Provide a short description for each service and a link to the corresponding YAML file.
   - Highlight cross-service interactions, such as how the Bootstrap service seeds the Awareness API.
2. **Expand the README** with instructions on generating code for each service.
   - Show example commands to regenerate a specific client or server.
   - Include troubleshooting tips for common errors in spec parsing or build failures.

## 4. Maintain the Agenda

- Update this document whenever a new service is added or an existing spec changes.
- Track progress with checkboxes for each generated client, server, and test suite.
- Ensure the documentation reflects the latest OpenAPI versions.

---

Following this agenda will lead to a complete set of FountainAI services implemented in Swift, each accompanied by an independent client SDK and clear documentation describing how they fit together.
