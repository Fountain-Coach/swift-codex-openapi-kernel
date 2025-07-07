#!/bin/bash
# Wraps `swift test -v` to limit line lengths for Codex
swift test -v 2>&1 | fold -sw 160
