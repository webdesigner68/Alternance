# 📁 Structure Complète des Fichiers

## 🗂️ Racine du projet

```
/workspace/
├── README.md                   # Documentation principale
├── QUICKSTART.md               # Guide démarrage rapide
├── ARCHITECTURE.md             # Documentation architecture
├── CONTRIBUTING.md             # Guide de contribution
├── PROJECT_SUMMARY.md          # Résumé du projet
├── NEXT_STEPS.md               # Prochaines étapes
├── FILE_STRUCTURE.md           # Ce fichier
├── MISSION.MD                  # Fichier mission original
├── pubspec.yaml                # Dépendances Flutter
├── analysis_options.yaml       # Configuration linter
├── build.yaml                  # Configuration build_runner
├── .gitignore                  # Fichiers ignorés par Git
├── env.example.json            # Exemple de configuration
└── env.json                    # Configuration (à créer)
```

## 📱 Android

```
android/
├── app/
│   ├── build.gradle            # Configuration Gradle
│   └── src/main/
│       ├── AndroidManifest.xml # Permissions & config
│       └── kotlin/com/apprentissage/la_bonne_alternance/
│           └── MainActivity.kt # Activity principale
├── build.gradle                # Gradle racine
├── settings.gradle             # Settings Gradle
└── gradle.properties           # Propriétés Gradle
```

## 🍎 iOS

```
ios/
└── Runner/
    ├── Info.plist              # Permissions & config iOS
    └── Runner.xcodeproj/
        └── project.pbxproj     # Projet Xcode
```

## 🎨 Assets

```
assets/
└── .gitkeep                    # Maintient le dossier
```

## 📚 Lib (Code principal)

### App (Configuration globale)

```
lib/app/
├── router.dart                 # Configuration GoRouter
└── theme.dart                  # Thèmes Material 3
```

### Core (Utilitaires)

```
lib/core/
├── config/
│   └── app_config.dart         # Config app (API keys, etc.)
├── errors/
│   └── failures.dart           # Types d'erreurs (Freezed)
├── providers/
│   └── app_providers.dart      # Providers Riverpod globaux
└── utils/
    ├── html_sanitizer.dart     # Nettoyage HTML
    ├── rate_limiter.dart       # Token bucket rate limiter
    └── validators.dart         # Validation formulaires
```

### Data (Couche données)

```
lib/data/
├── datasources/remote/
│   ├── dio_client_v2.dart              # Client HTTP v2
│   ├── dio_client_legacy.dart          # Client HTTP legacy
│   ├── job_remote_datasource.dart      # Datasource API v2
│   ├── job_legacy_datasource.dart      # Datasource API legacy
│   └── interceptors/
│       ├── auth_interceptor.dart       # Ajout headers auth
│       ├── content_type_guard_interceptor.dart  # Détection HTML/200
│       └── logging_interceptor.dart    # Logs (masqués en prod)
├── models/                              # Modèles Freezed + JSON
│   ├── job.dart                        # Modèle Job principal
│   ├── offer.dart                      # Détails de l'offre
│   ├── apply.dart                      # Info candidature
│   ├── contract.dart                   # Info contrat
│   ├── workplace.dart                  # Info entreprise
│   ├── location.dart                   # Localisation
│   ├── identifier.dart                 # Identifiant offre
│   ├── search_criteria.dart            # Critères de recherche
│   ├── search_response.dart            # Réponse recherche
│   ├── apply_request.dart              # Requête candidature
│   └── health_check.dart               # Health check API
└── repositories/
    └── job_repository_impl.dart        # Implémentation repository
```

### Domain (Couche métier)

```
lib/domain/
├── repositories/
│   └── job_repository.dart             # Interface repository
└── usecases/
    ├── search_offers.dart              # Use case recherche
    ├── get_offer_details.dart          # Use case détails
    ├── apply_to_offer.dart             # Use case candidature
    └── ping_health.dart                # Use case health check
```

### Features (Fonctionnalités)

```
lib/features/
├── onboarding/
│   └── presentation/
│       └── onboarding_screen.dart      # Écran configuration
├── search/
│   ├── application/
│   │   └── search_state_notifier.dart  # State recherche
│   └── presentation/
│       ├── search_screen.dart          # Écran recherche
│       └── widgets/
│           └── filter_bottom_sheet.dart # Filtres
├── details/
│   ├── application/
│   │   └── details_state_notifier.dart # State détails
│   └── presentation/
│       └── details_screen.dart         # Écran détails offre
├── apply/
│   ├── application/
│   │   └── apply_state_notifier.dart   # State candidature
│   └── presentation/
│       └── apply_screen.dart           # Écran candidature
└── settings/
    └── presentation/
        └── settings_screen.dart        # Écran paramètres
```

### Widgets (Composants réutilisables)

```
lib/widgets/
├── offer_card.dart             # Card offre (golden tested)
├── badges.dart                 # Badges (contrat, niveau, etc.)
├── html_description.dart       # Affichage HTML sanitizé
├── error_view.dart             # Affichage erreurs
└── skeleton_loading.dart       # Skeletons chargement
```

### Main

```
lib/
└── main.dart                   # Point d'entrée app
```

## 🧪 Tests

```
test/
├── core/utils/
│   ├── validators_test.dart            # Tests validateurs
│   └── html_sanitizer_test.dart        # Tests sanitizer
├── data/datasources/remote/
│   └── job_remote_datasource_test.dart # Tests datasource
├── widgets/
│   └── offer_card_test.dart            # Tests widget
└── golden/
    ├── offer_card_golden_test.dart     # Golden tests card
    └── skeleton_golden_test.dart       # Golden tests skeleton
```

## 🔧 Scripts

```
scripts/
├── setup.sh                    # Setup complet projet
├── generate.sh                 # Génération code (build_runner)
├── test.sh                     # Lancement tests
└── analyze.sh                  # Analyse code
```

## 🚀 CI/CD

```
.github/workflows/
└── ci.yml                      # GitHub Actions (analyze + test)
```

---

## 📊 Statistiques

- **Total fichiers créés** : 70+
- **Lignes de code** : ~4000+
- **Modèles Freezed** : 11
- **Écrans** : 5
- **Widgets réutilisables** : 5
- **Tests** : 6 fichiers
- **Documentation** : 7 fichiers
- **Scripts** : 4

---

## 🎯 Fichiers importants à connaître

### Pour commencer
1. **README.md** - Start here
2. **QUICKSTART.md** - Démarrage rapide
3. **NEXT_STEPS.md** - Que faire maintenant

### Pour développer
1. **lib/main.dart** - Entry point
2. **lib/app/router.dart** - Navigation
3. **lib/core/providers/app_providers.dart** - DI
4. **ARCHITECTURE.md** - Comprendre l'archi

### Pour contribuer
1. **CONTRIBUTING.md** - Guide contribution
2. **analysis_options.yaml** - Règles code
3. **test/** - Exemples de tests

### Pour configurer
1. **env.example.json** - Template config
2. **pubspec.yaml** - Dépendances
3. **android/app/src/main/AndroidManifest.xml** - Permissions Android
4. **ios/Runner/Info.plist** - Permissions iOS

---

## 🔍 Rechercher dans le code

### Trouver un modèle de données
```bash
find lib/data/models -name "*.dart"
```

### Trouver un écran
```bash
find lib/features -name "*_screen.dart"
```

### Trouver les tests
```bash
find test -name "*_test.dart"
```

### Trouver les providers
```bash
grep -r "Provider" lib/core/providers/
```

---

**Cette structure garantit :**
- ✅ Séparation claire des responsabilités
- ✅ Facilité de navigation
- ✅ Testabilité
- ✅ Maintenabilité
- ✅ Scalabilité
