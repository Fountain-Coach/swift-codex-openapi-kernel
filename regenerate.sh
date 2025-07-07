#!/usr/bin/env bash
set -euo pipefail

# Remove previous generated output
rm -rf Generated/Client Generated/Server

# Generate clients and servers for each FountainAI service version
for spec in FountainAi/openAPI/*/*.yml; do
    service=$(basename "$spec" .yml)
    outDir="Generated/$service"
    rm -rf "$outDir"
    swift run generator --input "$spec" --output "$outDir"

    mkdir -p "Generated/Client/$service" "Generated/Server/$service"
    cp -r "$outDir/Client/." "Generated/Client/$service/"
    cp -r "$outDir/Server/." "Generated/Server/$service/"
    if [ -f "$outDir/Models.swift" ]; then
        cp "$outDir/Models.swift" "Generated/Client/$service/Models.swift"
        cp "$outDir/Models.swift" "Generated/Server/$service/Models.swift"
    fi
    rm -rf "$outDir"
done
