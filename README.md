# La Bonne Alternance - Application Flutter

Application Flutter production-ready pour rechercher des offres d'alternance via l'API La Bonne Alternance.

## 📱 Fonctionnalités

- ✅ Recherche d'offres d'alternance (géolocalisée ou France entière)
- ✅ Filtres avancés (rayon, niveau diplôme, ROME, RNCP, départements, OPCO)
- ✅ Détails complets des offres
- ✅ Candidature en ligne avec upload CV
- ✅ Mode dégradé (legacy API) avec fallback automatique
- ✅ Thèmes clair/sombre
- ✅ Responsive (mobile & tablette)
- ✅ Offline cache
- ✅ Tests unitaires, widgets et golden

## 🏗️ Architecture

```
lib/
├── app/              # Bootstrap, themes, router
├── core/             # Config, errors, utils
├── data/             # Datasources, models, repositories
├── domain/           # Entities, usecases
├── features/         # Features (search, details, apply, settings)
└── widgets/          # Widgets réutilisables
```

**Stack technique:**
- Flutter 3.0+
- Riverpod (state management)
- go_router (routing + deep links)
- Dio (HTTP client)
- freezed + json_serializable (modèles immuables)
- Hive (cache offline)
- flutter_secure_storage (clé API)

## 🚀 Installation

### Prérequis

- Flutter 3.0.0 ou supérieur
- Dart 3.0.0 ou supérieur

```bash
flutter --version
```

### Étapes

1. **Cloner le projet**
```bash
git clone <repository-url>
cd la_bonne_alternance
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Générer le code (freezed, json_serializable)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Configurer l'environnement**

Créez un fichier `env.json` à la racine (copiez depuis `env.example.json`) :

```json
{
  "API_V2_BASE_URL": "https://api.apprentissage.beta.gouv.fr/api",
  "API_LEGACY_BASE_URL": "https://labonnealternance.apprentissage.beta.gouv.fr",
  "API_KEY_HEADER": "X-Api-Key",
  "API_KEY": "VOTRE_CLE_API_ICI",
  "SEARCH_DEFAULT_RADIUS_KM": 30,
  "CACHE_TTL_MINUTES": 30,
  "USE_AUTHORIZATION_HEADER": false,
  "ENABLE_LEGACY_FALLBACK": true
}
```

**⚠️ Important:** Ne commitez jamais `env.json` avec votre clé API.

5. **Lancer l'application**
```bash
flutter run --dart-define-from-file=env.json
```

## 🔑 Configuration de la clé API

### Obtenir une clé API

1. Rendez-vous sur [https://mission-apprentissage.gitbook.io/api/](https://mission-apprentissage.gitbook.io/api/)
2. Suivez la procédure pour obtenir une clé API v2
3. La clé peut prendre quelques jours pour être activée

### Configurer le header d'authentification

L'API supporte **deux méthodes d'authentification** (utilisez UN SEUL header) :

**Option A (recommandé) :** `X-Api-Key`
```json
{
  "API_KEY_HEADER": "X-Api-Key",
  "USE_AUTHORIZATION_HEADER": false
}
```

**Option B :** `Authorization: Api-Key`
```json
{
  "USE_AUTHORIZATION_HEADER": true
}
```

### Tester votre clé API

Dans l'app, allez dans **Paramètres** → **Test de santé API** pour vérifier que votre clé fonctionne.

## 🧪 Tests

### Tests unitaires
```bash
flutter test
```

### Tests avec coverage
```bash
flutter test --coverage
```

### Golden tests
```bash
flutter test test/golden
```

Pour mettre à jour les golden files :
```bash
flutter test --update-goldens
```

## 📡 API v2 - Documentation

### Base URL
```
https://api.apprentissage.beta.gouv.fr/api
```

### Endpoints

#### 🔍 Recherche d'offres
```bash
GET /job/v1/search
```

**Paramètres :**
- `latitude`, `longitude` (strings, 6 décimales) : coordonnées GPS
- `radius` (int, 0-200, défaut: 30) : rayon en km
- `romes` (CSV) : codes ROME (ex: `M1805,M1607`)
- `rncp` : code RNCP (ex: `RNCP34436`)
- `target_diploma_level` : "3"|"4"|"5"|"6"|"7"
- `opco` : nom de l'OPCO
- `departements` : paramètre répété (ex: `&departements=75&departements=06`)
- `partners_to_exclude` : paramètre répété

**Exemple cURL (X-Api-Key) :**
```bash
curl -i \
  -H "Accept: application/json" \
  -H "X-Api-Key: ${LBA_API_KEY}" \
  "https://api.apprentissage.beta.gouv.fr/api/job/v1/search?latitude=48.856613&longitude=2.352222&radius=30&romes=M1805"
```

**Exemple cURL (Authorization) :**
```bash
curl -i \
  -H "Accept: application/json" \
  -H "Authorization: Api-Key ${LBA_API_KEY}" \
  "https://api.apprentissage.beta.gouv.fr/api/job/v1/search?latitude=48.856613&longitude=2.352222&radius=30"
```

**Réponse :**
```json
{
  "jobs": [...],
  "recruiters": [...],
  "warnings": [...]
}
```

#### 📄 Détails d'une offre
```bash
GET /job/v1/offer/{id}
```

#### 📨 Candidature
```bash
POST /job/v1/apply
Content-Type: application/json
```

**Body :**
```json
{
  "applicant_first_name": "Jean",
  "applicant_last_name": "Dupont",
  "applicant_email": "jean.dupont@example.com",
  "applicant_phone": "+33612345678",
  "applicant_attachment_name": "cv.pdf",
  "applicant_attachment_content": "BASE64_ENCODED_CV",
  "recipient_id": "ID_FROM_SEARCH_RESULTS",
  "applicant_message": "Message optionnel"
}
```

**Succès :** HTTP 202

#### ❤️ Health Check
```bash
GET /healthcheck
```

## 🔄 Mode Dégradé (Legacy)

Si la clé API v2 n'est pas disponible, l'app bascule automatiquement en **mode dégradé** :

- Utilise l'API legacy : `https://labonnealternance.apprentissage.beta.gouv.fr/api/V1/jobs`
- Affiche un badge "⚠️ Mode dégradé"
- Fonctionnalités limitées (pas de candidature en ligne)
- Aucune authentification requise

**Exemple Legacy :**
```bash
curl "https://labonnealternance.apprentissage.beta.gouv.fr/api/V1/jobs?caller=LBA_FLUTTER_APP&romes=M1805&latitude=48.856613&longitude=2.352222&radius=30"
```

## 📱 Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Nous avons besoin de votre localisation pour trouver des offres près de chez vous</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Nous avons besoin d'accéder à vos fichiers pour télécharger votre CV</string>
```

## 🔒 Sécurité

- ✅ Clé API stockée dans `flutter_secure_storage`
- ✅ Jamais de log de la clé API en mode release
- ✅ CV encodé en Base64 en mémoire uniquement
- ✅ Purge des données sensibles après candidature
- ✅ Sanitization HTML (whitelist stricte)
- ✅ Validation des inputs côté client

## 🎨 UI/UX

- Material Design 3
- Thèmes clair/sombre
- Responsive (mobile + tablette)
- Skeletons pendant le chargement
- Gestion d'erreurs propre
- Accessibilité (labels sémantiques, 48dp touch targets)

## 🚢 Build & Déploiement

### Android

```bash
flutter build apk --release --dart-define-from-file=env.json
flutter build appbundle --release --dart-define-from-file=env.json
```

### iOS

```bash
flutter build ios --release --dart-define-from-file=env.json
```

### Web (optionnel)

```bash
flutter build web --release --dart-define-from-file=env.json
```

## 📝 TODO / Améliorations futures

- [ ] Carte interactive pour visualiser les offres
- [ ] Export des résultats (CSV/PDF)
- [ ] Favoris & historique de recherche
- [ ] Notifications push pour nouvelles offres
- [ ] Filtres sauvegardés
- [ ] Internationalisation (i18n)

## 🤝 Contribution

1. Fork le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

© 2025 Mission Apprentissage

## 📞 Support

- Documentation API : [https://mission-apprentissage.gitbook.io/api/](https://mission-apprentissage.gitbook.io/api/)
- Issues : [GitHub Issues](https://github.com/votre-repo/issues)

---

**Développé avec ❤️ en Flutter**
