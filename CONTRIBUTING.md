# Guide de Contribution

Merci de votre intérêt pour contribuer à **La Bonne Alternance** ! 🎉

## 🚀 Pour commencer

1. **Fork** le projet
2. **Clone** votre fork localement
3. **Créez une branche** pour votre fonctionnalité/fix
4. **Commitez** vos changements
5. **Push** vers votre fork
6. **Ouvrez une Pull Request**

## 📝 Normes de code

### Style

- Suivre les règles de `very_good_analysis`
- Utiliser `flutter format .` avant de committer
- Documenter les fonctions publiques (sauf widget simple)

### Architecture

- Respecter la Clean Architecture existante
- Nouveaux features dans `lib/features/`
- Widgets réutilisables dans `lib/widgets/`
- Models avec `freezed` + `json_serializable`

### Commits

Format des messages de commit :

```
type(scope): description courte

Description détaillée (optionnel)

Fixes #issue_number (si applicable)
```

Types :
- `feat`: nouvelle fonctionnalité
- `fix`: correction de bug
- `docs`: documentation
- `style`: formatage, pas de changement de code
- `refactor`: refactoring
- `test`: ajout/modification de tests
- `chore`: tâches de maintenance

Exemples :
```
feat(search): add filter by OPCO
fix(apply): fix CV upload on iOS
docs(readme): update API documentation
```

## 🧪 Tests

### Ajouter des tests pour :

- ✅ Nouveaux use cases (unit tests)
- ✅ Nouveaux widgets (widget tests)
- ✅ Nouvelles validations
- ✅ Nouveaux utils

### Lancer les tests

```bash
# Tous les tests
flutter test

# Tests spécifiques
flutter test test/path/to/test_file.dart

# Avec coverage
flutter test --coverage
```

## 🎨 UI/UX

- Respecter Material Design 3
- Tester en thème clair ET sombre
- Assurer l'accessibilité (labels, contraste, touch targets 48dp)
- Tester sur plusieurs tailles d'écran

## 🔒 Sécurité

- ⚠️ Ne jamais commiter de clé API
- Utiliser `flutter_secure_storage` pour les données sensibles
- Valider les inputs côté client
- Sanitizer tout HTML affiché

## 📋 Checklist avant PR

- [ ] Code formaté (`flutter format .`)
- [ ] Pas d'erreurs d'analyse (`flutter analyze`)
- [ ] Tests ajoutés et passants (`flutter test`)
- [ ] README/docs mis à jour si nécessaire
- [ ] Pas de logs/prints inutiles
- [ ] Testé en debug ET release
- [ ] Testé sur iOS ET Android (si modif native)

## 🐛 Signaler un bug

Utilisez les GitHub Issues avec :

1. **Description** claire du problème
2. **Étapes pour reproduire**
3. **Comportement attendu** vs actuel
4. **Environnement** (Flutter version, OS, device)
5. **Logs/screenshots** si pertinent

## 💡 Proposer une fonctionnalité

Ouvrez une issue avec :

1. **Use case** : pourquoi cette fonctionnalité ?
2. **Description** détaillée
3. **Mockups/wireframes** si possible
4. **Complexité estimée**

## 📞 Questions ?

- Ouvrez une **Discussion** sur GitHub
- Consultez la [documentation API](https://mission-apprentissage.gitbook.io/api/)

---

**Merci de contribuer ! 🙏**
