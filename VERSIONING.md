# Versioning Policy

FountainAI services and the OpenAPI generator follow [Semantic Versioning](https://semver.org/).

- **API directories** under `FountainAi/openAPI/v<major>/` indicate the public **major** version.
- Breaking API changes create a new `v<major>` directory.
- Within a major version, backwards‑compatible additions bump the **minor** version.
- Bug fixes and documentation updates bump the **patch** version.

Every change to an API spec or the generator must be recorded in `CHANGELOG.md` with the corresponding version number.
