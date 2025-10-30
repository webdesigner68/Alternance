#!/bin/bash

echo "🔨 Generating code with build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -eq 0 ]; then
    echo "✅ Code generation completed successfully!"
else
    echo "❌ Code generation failed!"
    exit 1
fi
