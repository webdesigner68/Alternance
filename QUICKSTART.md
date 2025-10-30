# 🚀 Guide de Démarrage Rapide

## Installation en 5 minutes

### 1. Cloner et installer

```bash
cd /workspace
flutter pub get
```

### 2. Générer le code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Cela génère tous les fichiers `.freezed.dart` et `.g.dart` nécessaires pour les modèles de données.

### 3. Configurer l'API (optionnel)

Si vous avez déjà une clé API :

```bash
cp env.example.json env.json
# Éditez env.json et ajoutez votre clé
```

Sinon, l'app vous guidera lors du premier lancement.

### 4. Lancer l'app

```bash
flutter run
```

Ou avec la config env :

```bash
flutter run --dart-define-from-file=env.json
```

## 🧪 Tester rapidement

### Lancer les tests

```bash
flutter test
```

### Tester l'API (sans l'app)

```bash
# Remplacez YOUR_API_KEY par votre clé
export LBA_API_KEY="YOUR_API_KEY"

# Test recherche autour de Paris
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

## 📱 Premier usage de l'app

1. **Écran d'onboarding**
   - Collez votre clé API
   - Choisissez le type de header (X-Api-Key ou Authorization)
   - Testez la clé
   - Autorisez la localisation (optionnel)

2. **Écran de recherche**
   - Tapez "Autour de moi" pour une recherche géolocalisée
   - Ou utilisez les filtres pour une recherche personnalisée
   - Les résultats s'affichent en liste

3. **Voir les détails**
   - Tapez sur une offre pour voir tous les détails
   - Informations entreprise, contrat, compétences, etc.

4. **Postuler**
   - Si l'offre le permet, postulez directement depuis l'app
   - Remplissez le formulaire
   - Ajoutez votre CV (PDF/DOC)
   - Envoyez votre candidature

## 🔧 Dépannage

### Problème : "ApiException: Clé invalide"

- Vérifiez que votre clé API est correcte
- Vérifiez le type de header (X-Api-Key vs Authorization)
- La clé peut prendre quelques jours pour être activée
- En attendant, utilisez le mode dégradé (legacy)

### Problème : "No location permission"

- Autorisez la localisation dans les paramètres de l'app
- Ou utilisez la recherche sans localisation (France entière)

### Problème : Erreurs de build

```bash
# Nettoyez et régénérez
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎯 Fonctionnalités clés

- ✅ **Recherche géolocalisée** : Trouve les offres près de vous
- ✅ **Filtres avancés** : Rayon, niveau, ROME, département, OPCO
- ✅ **Candidature en ligne** : Upload CV et postulez directement
- ✅ **Mode dégradé** : Fonctionne même sans clé API v2
- ✅ **Offline** : Cache les derniers résultats
- ✅ **Thèmes** : Clair/sombre

## 📚 Ressources

- [README complet](README.md)
- [Documentation API](https://mission-apprentissage.gitbook.io/api/)
- [Flutter docs](https://docs.flutter.dev/)

---

**Besoin d'aide ?** Ouvrez une issue sur GitHub !
