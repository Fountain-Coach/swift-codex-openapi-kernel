#!/usr/bin/env bash
set -euo pipefail

# Remove previous generated output
rm -rf Generated/Client Generated/Server

# Regenerate client and server code from the OpenAPI spec
swift run generator --input OpenAPI/api.yaml --output Generated
