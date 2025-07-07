# Instructions for Codex Agents

This repository uses Swift 6 and Swift Package Manager.

## Testing
- Always run `swift test -v` after making changes.
- If tests fail because Swift or system dependencies are missing, install them via:
  ```bash
  sudo apt-get update && sudo apt-get install -y clang libicu-dev swift
  ```
- Summarize the test results in the PR description.
