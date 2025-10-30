# 🚀 Prochaines Étapes

## ⚡ Démarrage rapide (3 commandes)

```bash
# 1. Installer les dépendances et générer le code
./scripts/setup.sh

# 2. (Optionnel) Ajouter votre clé API dans env.json
nano env.json

# 3. Lancer l'app
flutter run
```

C'est tout ! L'application va se lancer et vous guider pour la configuration.

---

## 📋 Détails complets

### Étape 1 : Setup automatique

```bash
cd /workspace
./scripts/setup.sh
```

Ce script va :
- ✅ Installer toutes les dépendances (`flutter pub get`)
- ✅ Générer les fichiers Freezed et JSON (`build_runner`)
- ✅ Créer env.json depuis l'exemple

**Alternative manuelle :**
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cp env.example.json env.json
```

### Étape 2 : Configuration (optionnel)

Si vous avez déjà une clé API, éditez `env.json` :

```json
{
  "API_V2_BASE_URL": "https://api.apprentissage.beta.gouv.fr/api",
  "API_LEGACY_BASE_URL": "https://labonnealternance.apprentissage.beta.gouv.fr",
  "API_KEY_HEADER": "X-Api-Key",
  "API_KEY": "VOTRE_CLE_ICI",
  "SEARCH_DEFAULT_RADIUS_KM": 30,
  "CACHE_TTL_MINUTES": 30,
  "USE_AUTHORIZATION_HEADER": false,
  "ENABLE_LEGACY_FALLBACK": true
}
```

**Si vous n'avez pas de clé :**
- Pas de problème ! L'app fonctionnera en mode dégradé
- Vous pourrez configurer la clé depuis l'interface de l'app

### Étape 3 : Lancer l'app

**Sans configuration env.json :**
```bash
flutter run
```

**Avec env.json :**
```bash
flutter run --dart-define-from-file=env.json
```

**Choisir un device spécifique :**
```bash
flutter devices
flutter run -d <device-id>
```

### Étape 4 : Premier usage de l'app

1. **Écran d'onboarding**
   - Si pas de clé configurée : collez votre clé API
   - Choisissez le type de header (X-Api-Key recommandé)
   - Testez la connexion
   - Autorisez la localisation (optionnel)

2. **Recherche**
   - Tapez "Autour de moi" pour une recherche géolocalisée
   - Ou passez en mode dégradé pour tester sans clé

3. **Explorer**
   - Parcourez les offres
   - Voir les détails
   - Postuler en ligne

---

## 🧪 Vérifier que tout fonctionne

### Tests automatiques
```bash
# Lancer tous les tests
./scripts/test.sh

# Ou manuellement
flutter test

# Avec coverage
flutter test --coverage
```

### Analyse du code
```bash
# Vérifier qu'il n'y a pas d'erreurs
./scripts/analyze.sh

# Ou manuellement
flutter analyze
```

### Formater le code
```bash
flutter format .
```

---

## 🔧 Dépannage

### Problème : "No such file build_runner"

**Solution :**
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problème : "Clé API invalide"

**Solutions possibles :**
1. Vérifiez que la clé est correcte dans env.json
2. Testez avec le bon header (X-Api-Key vs Authorization)
3. La clé peut prendre quelques jours pour être activée
4. Utilisez le mode dégradé en attendant

### Problème : Build Android échoue

**Solution :**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Problème : Build iOS échoue

**Solution :**
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

### Problème : "Permission denied" sur les scripts

**Solution :**
```bash
chmod +x scripts/*.sh
```

---

## 📱 Build pour production

### Android APK
```bash
flutter build apk --release --dart-define-from-file=env.json
```

### Android App Bundle (pour Play Store)
```bash
flutter build appbundle --release --dart-define-from-file=env.json
```

### iOS
```bash
flutter build ios --release --dart-define-from-file=env.json
```

**Note :** Pour iOS, vous devez ouvrir Xcode et configurer les certificats.

---

## 🌐 Tester l'API manuellement

Si vous voulez tester l'API directement :

```bash
# Définir votre clé
export LBA_API_KEY="votre_cle_ici"

# Test recherche
curl -i \
  -H "Accept: application/json" \
  -H "X-Api-Key: $LBA_API_KEY" \
  "https://api.apprentissage.beta.gouv.fr/api/job/v1/search?latitude=48.856613&longitude=2.352222&radius=30"

# Test health check
curl -i \
  -H "Accept: application/json" \
  -H "X-Api-Key: $LBA_API_KEY" \
  "https://api.apprentissage.beta.gouv.fr/api/healthcheck"
```

---

## 📚 Documentation complète

- **[README.md](README.md)** - Documentation principale
- **[QUICKSTART.md](QUICKSTART.md)** - Guide de démarrage rapide
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architecture détaillée
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Guide de contribution
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Résumé complet du projet

---

## 🎯 Que faire ensuite ?

1. ✅ **Tester l'app** sur votre device/émulateur
2. ✅ **Parcourir le code** pour comprendre l'architecture
3. ✅ **Ajouter des features** (carte, favoris, notifications)
4. ✅ **Personnaliser** le design selon vos besoins
5. ✅ **Déployer** sur les stores

---

## 💡 Ressources utiles

- [Documentation API La Bonne Alternance](https://mission-apprentissage.gitbook.io/api/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)

---

## 🤝 Besoin d'aide ?

- Consultez les issues GitHub
- Lisez la documentation complète
- Ouvrez une discussion

---

**🎉 Bon développement !**
