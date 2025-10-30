# 🚀 Options de Déploiement et Lancement

## 📋 Résumé des Options

| Option | Difficulté | Temps Setup | Recommandé pour |
|--------|-----------|-------------|-----------------|
| **Machine locale** | ⭐ Facile | 10 min | Développement quotidien |
| **Web (Chrome)** | ⭐ Facile | 5 min | Test rapide sans émulateur |
| **Docker** | ⭐⭐ Moyen | 15 min | Déploiement serveur |
| **GitPod** | ⭐ Facile | 0 min | Développement cloud |
| **Build Production** | ⭐⭐⭐ Avancé | 30 min+ | Distribution stores |

---

## 1. 💻 Machine Locale (Recommandé)

### Installation Flutter

**macOS :**
```bash
# Avec Homebrew
brew install --cask flutter

# Vérifier
flutter doctor
```

**Linux :**
```bash
# Télécharger Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz

# Ajouter au PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Vérifier
flutter doctor
```

**Windows :**
- Télécharger depuis https://docs.flutter.dev/get-started/install/windows
- Suivre l'assistant d'installation

### Lancer l'App

```bash
cd /workspace

# Script automatique (Mac/Linux)
./install_and_run.sh

# Ou manuellement
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 2. 🌐 Mode Web (Sans Émulateur)

Le plus rapide pour tester sans installer d'émulateur !

```bash
cd /workspace

# Setup initial
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Activer le web
flutter config --enable-web

# Lancer sur Chrome
flutter run -d chrome

# Ou sur Edge
flutter run -d edge
```

**Pour un serveur web local :**
```bash
# Build
flutter build web --release

# Servir avec Python
cd build/web
python3 -m http.server 8080

# Ou avec Node.js
npx http-server -p 8080

# Ouvrir http://localhost:8080
```

---

## 3. 🐳 Docker

### Option A : Mode Développement

```bash
cd /workspace

# Build l'image
docker build -t lba-app .

# Lancer
docker run -p 8080:8080 lba-app

# Ouvrir http://localhost:8080
```

### Option B : Docker Compose

```bash
cd /workspace

# Lancer
docker-compose up

# Avec rebuild
docker-compose up --build

# En background
docker-compose up -d

# Logs
docker-compose logs -f
```

### Option C : Production avec Nginx

```bash
# Build web
flutter build web --release

# Lancer le serveur statique
docker-compose --profile static up lba-static

# Ouvrir http://localhost:8081
```

---

## 4. ☁️ GitPod (Développement Cloud)

### Méthode 1 : URL directe

```
https://gitpod.io/#https://github.com/VOTRE-REPO/la_bonne_alternance
```

### Méthode 2 : Badge README

Ajoutez au README.md :
```markdown
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/VOTRE-REPO/la_bonne_alternance)
```

### Dans GitPod

Le fichier `.gitpod.yml` est déjà configuré. L'app se lancera automatiquement :

```bash
# Dans le terminal GitPod
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

GitPod ouvrira automatiquement une preview.

---

## 5. 📱 Émulateurs

### Android Emulator

```bash
# Lister les AVDs
flutter emulators

# Lancer un émulateur
flutter emulators --launch <emulator-id>

# Ou depuis Android Studio
# Tools > AVD Manager > Play button
```

### iOS Simulator (Mac uniquement)

```bash
# Lister les simulateurs
xcrun simctl list devices

# Lancer un simulateur
open -a Simulator

# Ou
flutter emulators --launch apple_ios_simulator
```

---

## 6. 📦 Build Production

### Android APK

```bash
# Debug
flutter build apk

# Release
flutter build apk --release --dart-define-from-file=env.json

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release --dart-define-from-file=env.json

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Mac uniquement)

```bash
flutter build ios --release --dart-define-from-file=env.json

# Puis ouvrir Xcode pour signer et publier
open ios/Runner.xcworkspace
```

### Web

```bash
flutter build web --release --dart-define-from-file=env.json

# Output: build/web/
# Déployer sur Firebase Hosting, Vercel, Netlify, etc.
```

---

## 7. 🌍 Déploiement Cloud

### Vercel (Web)

```bash
# Installer Vercel CLI
npm i -g vercel

# Build
flutter build web --release

# Deploy
cd build/web
vercel --prod
```

### Firebase Hosting (Web)

```bash
# Installer Firebase CLI
npm i -g firebase-tools

# Login
firebase login

# Init
firebase init hosting

# Build
flutter build web --release

# Deploy
firebase deploy
```

### Heroku (Web via Docker)

```bash
# Créer app
heroku create lba-app

# Push avec Dockerfile
git push heroku main
```

---

## 🔧 Dépannage

### "Flutter command not found"

Installez Flutter : https://docs.flutter.dev/get-started/install

### "No devices available"

```bash
# Vérifier les devices
flutter devices

# Pour Web
flutter config --enable-web

# Pour Android
# Ouvrir Android Studio > AVD Manager

# Pour iOS (Mac)
# Ouvrir Xcode > Simulators
```

### "Build runner errors"

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### "Clé API invalide"

L'app fonctionne en mode dégradé sans clé. Vous pouvez :
1. Configurer la clé depuis l'app
2. Éditer `env.json`
3. Utiliser le mode legacy

---

## 📊 Tableau Comparatif

| Plateforme | Commande | Port | URL |
|------------|----------|------|-----|
| Chrome | `flutter run -d chrome` | - | Auto |
| Web Server | `flutter run -d web-server --web-port 8080` | 8080 | http://localhost:8080 |
| Docker | `docker-compose up` | 8080 | http://localhost:8080 |
| Android | `flutter run` | - | Sur device |
| iOS | `flutter run` | - | Sur simulator |

---

## 🎯 Recommandations

**Pour développer :**
- Machine locale + Android Emulator
- Ou GitPod pour développement cloud

**Pour tester rapidement :**
- Mode Web (Chrome)

**Pour déployer :**
- Android : Play Store (App Bundle)
- iOS : App Store
- Web : Firebase Hosting / Vercel

---

## 📞 Besoin d'Aide ?

- [Documentation Flutter](https://docs.flutter.dev/)
- [HOW_TO_RUN.md](HOW_TO_RUN.md) - Guide détaillé
- [README.md](README.md) - Documentation complète

---

**🎉 Choisissez l'option qui vous convient et lancez l'app !**
