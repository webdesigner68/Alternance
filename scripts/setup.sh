#!/bin/bash

echo "🚀 Setting up La Bonne Alternance project..."

echo "📦 Installing dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies!"
    exit 1
fi

echo "🔨 Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo "❌ Failed to generate code!"
    exit 1
fi

echo "📝 Creating env.json from example..."
if [ ! -f env.json ]; then
    cp env.example.json env.json
    echo "⚠️  Don't forget to add your API key in env.json!"
else
    echo "ℹ️  env.json already exists, skipping..."
fi

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "Next steps:"
echo "  1. Add your API key in env.json"
echo "  2. Run: flutter run --dart-define-from-file=env.json"
echo ""
