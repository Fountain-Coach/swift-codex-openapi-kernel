# FountainAI Service Catalog

This directory contains the OpenAPI specifications for each FountainAI microservice. Specifications are grouped by API version so that multiple revisions can coexist.

| Service | Entrypoint | Description | Spec |
| --- | --- | --- | --- |
| Baseline Awareness | http://awareness.fountain.coach/api/v1 | Manages baselines, drift, patterns, reflection data and semantic analytics. | [v1/baseline-awareness.yml](v1/baseline-awareness.yml) |
| Bootstrap | http://bootstrap.fountain.coach/api/v1 | Initializes corpora, seeds GPT roles and adds baseline snapshots. Relies on the Awareness API to store initial artifacts. | [v1/bootstrap.yml](v1/bootstrap.yml) |
| Function Caller | http://functions.fountain.coach/api/v1 | Maps OpenAI function-calling plans to HTTP operations. Retrieves definitions from the Tools Factory. | [v1/function-caller.yml](v1/function-caller.yml) |
| LLM Gateway | http://llm-gateway.fountain.coach/api/v1 | Proxies requests to any LLM with function-calling support. Used by the Planner for LLM-driven tasks. | [v2/llm-gateway.yml](v2/llm-gateway.yml) |
| Persistence | http://persist.fountain.coach/api/v1 | Typesense-backed store for baselines, drifts, reflections and registered tools. | [v1/persist.yml](v1/persist.yml) |
| Planner | http://planner.fountain.coach/api/v1 | Orchestrates planning workflows across the LLM Gateway and Function Caller. | [v0/planner.yml](v0/planner.yml) |
| Tools Factory | http://tools-factory.fountain.coach/api/v1 | Registers new tool definitions in the shared Typesense collection consumed by the Function Caller. | [v1/tools-factory.yml](v1/tools-factory.yml) |

### Cross-service Interactions

- **Bootstrap → Awareness**: bootstrap operations seed corpora and baseline snapshots by calling the Awareness API.
- **Tools Factory → Function Caller**: the Tools Factory persists function definitions that the Function Caller dynamically invokes.
- **Planner → LLM Gateway & Function Caller**: the Planner coordinates with the LLM Gateway for language model responses and triggers registered functions through the Function Caller.

