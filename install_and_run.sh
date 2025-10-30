#!/bin/bash

echo "🚀 Installation et lancement de La Bonne Alternance"
echo ""

# Vérifier Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé sur cette machine"
    echo ""
    echo "Pour installer Flutter :"
    echo "  • Mac : https://docs.flutter.dev/get-started/install/macos"
    echo "  • Linux : https://docs.flutter.dev/get-started/install/linux"
    echo "  • Windows : https://docs.flutter.dev/get-started/install/windows"
    echo ""
    exit 1
fi

echo "✅ Flutter détecté : $(flutter --version | head -n 1)"
echo ""

# Setup
echo "📦 Installation des dépendances..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des dépendances"
    exit 1
fi

echo ""
echo "🔨 Génération du code (Freezed, JSON)..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la génération du code"
    exit 1
fi

# Config
echo ""
if [ ! -f env.json ]; then
    echo "📝 Création de env.json depuis l'exemple..."
    cp env.example.json env.json
    echo "⚠️  N'oubliez pas d'ajouter votre clé API dans env.json"
    echo "   Ou lancez l'app pour la configurer via l'interface"
else
    echo "✅ env.json existe déjà"
fi

# Lister les devices
echo ""
echo "📱 Devices disponibles :"
flutter devices

echo ""
echo "🚀 Lancement de l'app..."
echo ""

# Lancer (l'utilisateur peut Ctrl+C et choisir un device)
flutter run

echo ""
echo "✅ Terminé !"
