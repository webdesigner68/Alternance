# 🚀 Comment Lancer l'Application

## ⚠️ Flutter non disponible dans cet environnement

L'environnement actuel ne dispose pas de Flutter. Voici les options pour lancer l'app :

---

## Option 1 : Sur votre machine locale (Recommandé)

### Prérequis
- Flutter SDK 3.0+ installé
- Android Studio / Xcode (pour émulateurs)
- Un device Android/iOS ou émulateur

### Étapes

1. **Cloner ou copier le projet sur votre machine**
```bash
# Si le projet est sur GitHub
git clone <repo-url>
cd la_bonne_alternance

# Ou copiez les fichiers depuis /workspace
```

2. **Installer Flutter si nécessaire**
```bash
# Vérifier si Flutter est installé
flutter --version

# Sinon, installer depuis https://docs.flutter.dev/get-started/install
```

3. **Setup du projet**
```bash
# Installer les dépendances
flutter pub get

# Générer le code (Freezed, JSON)
flutter pub run build_runner build --delete-conflicting-outputs

# Créer env.json (optionnel)
cp env.example.json env.json
# Éditez env.json et ajoutez votre clé API si vous en avez une
```

4. **Lancer l'app**

**Option A : Sans configuration (mode dégradé)**
```bash
flutter run
```

**Option B : Avec configuration API**
```bash
flutter run --dart-define-from-file=env.json
```

**Option C : Choisir un device spécifique**
```bash
# Lister les devices disponibles
flutter devices

# Lancer sur un device spécifique
flutter run -d <device-id>

# Exemples :
flutter run -d chrome        # Web (Chrome)
flutter run -d edge          # Web (Edge)
flutter run -d emulator-5554 # Émulateur Android
```

---

## Option 2 : Lancer en mode Web

Si vous ne voulez pas installer d'émulateur, lancez en mode web :

```bash
# Activer le web support
flutter config --enable-web

# Lancer sur Chrome
flutter run -d chrome

# Ou build pour déploiement
flutter build web
cd build/web
python3 -m http.server 8000
# Puis ouvrez http://localhost:8000
```

---

## Option 3 : Docker (pour développement)

Créez un Dockerfile Flutter :

```dockerfile
FROM cirrusci/flutter:stable

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter pub run build_runner build --delete-conflicting-outputs

EXPOSE 8080
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
```

Puis :
```bash
docker build -t lba-app .
docker run -p 8080:8080 lba-app
```

---

## Option 4 : GitPod / Cloud IDE

Si vous utilisez un IDE cloud :

1. **GitPod** : Ajoutez `.gitpod.yml`
```yaml
tasks:
  - init: |
      flutter pub get
      flutter pub run build_runner build --delete-conflicting-outputs
  - command: flutter run -d web-server --web-port 8080
ports:
  - port: 8080
    onOpen: open-preview
```

2. **GitHub Codespaces** : Similaire à GitPod

---

## 🔧 Dépannage

### "build_runner not found"
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### "No devices available"
```bash
# Pour Android
# Ouvrir Android Studio > AVD Manager > Créer un émulateur

# Pour iOS (Mac uniquement)
# Ouvrir Xcode > Window > Devices and Simulators

# Pour Web
flutter config --enable-web
flutter run -d chrome
```

### "Clé API invalide"
- L'app fonctionne sans clé en mode dégradé
- Configurez la clé depuis l'interface de l'app
- Ou éditez `env.json`

---

## 📱 Devices recommandés pour tester

**Android :**
- Émulateur Pixel 6 (Android 13)
- Device physique en mode développeur

**iOS :**
- iPhone 14 Simulator (iOS 16)
- iPad Air Simulator

**Web :**
- Chrome (recommandé)
- Edge
- Firefox

---

## 🎯 Après le lancement

1. **Écran d'onboarding** apparaît en premier
2. Configurez votre clé API (ou passez en mode dégradé)
3. Autorisez la localisation (optionnel)
4. Commencez à rechercher des offres !

---

## 📚 Plus d'informations

- [QUICKSTART.md](QUICKSTART.md) - Guide rapide
- [README.md](README.md) - Documentation complète
- [Flutter Get Started](https://docs.flutter.dev/get-started/install)

---

## 💡 Script d'installation automatique (Mac/Linux)

Créez `install_and_run.sh` :

```bash
#!/bin/bash

echo "🚀 Installation et lancement de La Bonne Alternance"

# Vérifier Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé"
    echo "Installez Flutter depuis : https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Setup
echo "📦 Installation des dépendances..."
flutter pub get

echo "🔨 Génération du code..."
flutter pub run build_runner build --delete-conflicting-outputs

# Config
if [ ! -f env.json ]; then
    echo "📝 Création de env.json..."
    cp env.example.json env.json
    echo "⚠️  Pensez à ajouter votre clé API dans env.json"
fi

# Lancer
echo "🚀 Lancement de l'app..."
flutter run

echo "✅ Terminé !"
```

Puis :
```bash
chmod +x install_and_run.sh
./install_and_run.sh
```

---

**🎉 Une fois Flutter installé, l'app se lancera en quelques commandes !**
