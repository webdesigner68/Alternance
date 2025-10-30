#!/bin/bash

echo "🧪 Running tests..."
flutter test

if [ $? -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed!"
    exit 1
fi
