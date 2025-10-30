# 🏗️ Architecture du Projet

## Vue d'ensemble

Ce projet suit une **Clean Architecture** avec séparation claire des responsabilités.

```
┌─────────────────────────────────────────────────┐
│                  Presentation                    │
│        (Widgets, Screens, State Notifiers)      │
├─────────────────────────────────────────────────┤
│                   Application                    │
│              (Use Cases, Business Logic)         │
├─────────────────────────────────────────────────┤
│                     Domain                       │
│            (Entities, Repositories Interface)    │
├─────────────────────────────────────────────────┤
│                      Data                        │
│        (Datasources, Models, Repository Impl)    │
└─────────────────────────────────────────────────┘
```

## Structure des dossiers

```
lib/
├── app/
│   ├── router.dart           # GoRouter configuration
│   └── theme.dart            # Material 3 themes
│
├── core/
│   ├── config/
│   │   └── app_config.dart   # Configuration globale
│   ├── errors/
│   │   └── failures.dart     # Types d'erreurs (freezed)
│   ├── providers/
│   │   └── app_providers.dart # Providers Riverpod principaux
│   └── utils/
│       ├── html_sanitizer.dart
│       ├── rate_limiter.dart
│       └── validators.dart
│
├── data/
│   ├── datasources/
│   │   └── remote/
│   │       ├── dio_client_v2.dart
│   │       ├── dio_client_legacy.dart
│   │       ├── job_remote_datasource.dart
│   │       ├── job_legacy_datasource.dart
│   │       └── interceptors/
│   │           ├── auth_interceptor.dart
│   │           ├── content_type_guard_interceptor.dart
│   │           └── logging_interceptor.dart
│   ├── models/               # Freezed models + JSON serialization
│   │   ├── job.dart
│   │   ├── offer.dart
│   │   ├── apply.dart
│   │   ├── search_criteria.dart
│   │   └── ...
│   └── repositories/
│       └── job_repository_impl.dart
│
├── domain/
│   ├── repositories/
│   │   └── job_repository.dart
│   └── usecases/
│       ├── search_offers.dart
│       ├── get_offer_details.dart
│       ├── apply_to_offer.dart
│       └── ping_health.dart
│
├── features/
│   ├── onboarding/
│   │   └── presentation/
│   │       └── onboarding_screen.dart
│   ├── search/
│   │   ├── application/
│   │   │   └── search_state_notifier.dart
│   │   └── presentation/
│   │       ├── search_screen.dart
│   │       └── widgets/
│   │           └── filter_bottom_sheet.dart
│   ├── details/
│   │   ├── application/
│   │   │   └── details_state_notifier.dart
│   │   └── presentation/
│   │       └── details_screen.dart
│   ├── apply/
│   │   ├── application/
│   │   │   └── apply_state_notifier.dart
│   │   └── presentation/
│   │       └── apply_screen.dart
│   └── settings/
│       └── presentation/
│           └── settings_screen.dart
│
├── widgets/                  # Widgets réutilisables
│   ├── offer_card.dart
│   ├── badges.dart
│   ├── html_description.dart
│   ├── error_view.dart
│   └── skeleton_loading.dart
│
└── main.dart                 # Entry point
```

## Flux de données

### Recherche d'offres

```
User tap "Rechercher"
    ↓
SearchScreen
    ↓
SearchStateNotifier
    ↓
SearchOffersUseCase
    ↓
JobRepository
    ↓
JobRemoteDatasource (ou Legacy si fallback)
    ↓
DioClientV2 + Interceptors
    ↓
API La Bonne Alternance
    ↓
Response → Models (freezed)
    ↓
State mise à jour
    ↓
UI rebuild
```

## Patterns utilisés

### 1. Clean Architecture

- **Séparation des couches** : Presentation, Domain, Data
- **Dependency Inversion** : Les couches hautes ne dépendent pas des couches basses
- **Repository Pattern** : Abstraction de la source de données

### 2. State Management (Riverpod)

```dart
// Provider d'un use case
final searchOffersUseCaseProvider = Provider<SearchOffersUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return SearchOffersUseCase(repository);
});

// StateNotifier pour gérer l'état de la recherche
class SearchStateNotifier extends StateNotifier<SearchState> {
  SearchStateNotifier(this.ref) : super(SearchState());
  
  final Ref ref;
  
  Future<void> search(SearchCriteria criteria) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final useCase = ref.read(searchOffersUseCaseProvider);
      final response = await useCase(criteria);
      state = state.copyWith(isLoading: false, response: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    }
  }
}
```

### 3. Immutable Data Models (Freezed)

```dart
@freezed
class Job with _$Job {
  const factory Job({
    required Identifier identifier,
    Workplace? workplace,
    Contract? contract,
    required Offer offer,
    Apply? apply,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
```

### 4. Dependency Injection

Riverpod gère l'injection de dépendances :

```dart
// Dans app_providers.dart
final dioClientV2Provider = Provider<DioClientV2>((ref) {
  final config = ref.watch(appConfigProvider).value!;
  return DioClientV2(config);
});

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final remoteDatasource = ref.watch(jobRemoteDatasourceProvider);
  final legacyDatasource = ref.watch(jobLegacyDatasourceProvider);
  return JobRepositoryImpl(
    remoteDatasource: remoteDatasource,
    legacyDatasource: legacyDatasource,
  );
});
```

## Gestion des erreurs

### Failure (freezed union)

```dart
@freezed
class Failure with _$Failure {
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.unauthorized({required String message}) = UnauthorizedFailure;
  const factory Failure.invalidResponse({required String message}) = InvalidResponseFailure;
  // ...
}
```

### Affichage dans l'UI

```dart
if (state.failure != null) {
  return ErrorView(
    failure: state.failure!,
    onRetry: _retry,
  );
}
```

## Sécurité

### 1. Authentification

- Un seul header d'auth envoyé à la fois
- Clé stockée dans `flutter_secure_storage`
- Logs masqués en production

### 2. Sanitization HTML

```dart
class HtmlSanitizer {
  static const _allowedTags = {'b', 'i', 'em', 'strong', 'p', 'br', 'ul', 'li'};
  
  static String sanitize(String htmlContent) {
    // Whitelist strict
  }
}
```

### 3. Validation des données

```dart
class Validators {
  static String? validateEmail(String? value) {
    // Regex strict
  }
  
  static String? validatePhone(String? value) {
    // Format européen
  }
}
```

## Performance

### 1. Cache (Hive)

- Stockage local des derniers résultats
- TTL configurable
- Lecture/écriture rapide

### 2. Skeletons

- Affichage immédiat pendant le chargement
- Améliore la perception de performance

### 3. Lazy loading

- Providers chargés à la demande
- Assets chargés on-demand

## Tests

### 1. Unit Tests

```dart
test('should format lat/lon to 6 decimals', () {
  const criteria = SearchCriteria(
    latitude: 48.856613123456,
    longitude: 2.352222987654,
  );
  
  expect(criteria.latitude!.toStringAsFixed(6), '48.856613');
});
```

### 2. Widget Tests

```dart
testWidgets('should display job title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: OfferCard(job: mockJob)),
  );
  
  expect(find.text('Développeur Flutter'), findsOneWidget);
});
```

### 3. Golden Tests

```dart
testGoldens('OfferCard light theme', (tester) async {
  await tester.pumpWidgetBuilder(
    OfferCard(job: mockJob),
    wrapper: materialAppWrapper(theme: ThemeData.light()),
  );
  
  await screenMatchesGolden(tester, 'offer_card_light');
});
```

## Évolutivité

### Ajouter un nouveau use case

1. Créer l'interface dans `domain/repositories/`
2. Créer le use case dans `domain/usecases/`
3. Implémenter dans le repository
4. Ajouter le provider dans `app_providers.dart`
5. Utiliser dans l'UI via StateNotifier

### Ajouter une nouvelle source de données

1. Créer le datasource dans `data/datasources/`
2. Ajouter au repository implementation
3. Tester avec mock

---

**Cette architecture garantit :**
- ✅ Testabilité
- ✅ Maintenabilité
- ✅ Scalabilité
- ✅ Séparation des responsabilités
