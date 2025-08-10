#!/bin/bash
# Continuous Integration script for Guishap

set -e

echo "🏗️  Building Guishap..."
make clean
make all

echo "🧪 Running test suite..."
make test

echo "✅ All CI checks passed!"
