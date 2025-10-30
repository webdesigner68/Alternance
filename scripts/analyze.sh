#!/bin/bash

echo "🔍 Analyzing code..."
flutter analyze

if [ $? -eq 0 ]; then
    echo "✅ No issues found!"
else
    echo "⚠️ Issues found, please fix them"
    exit 1
fi
