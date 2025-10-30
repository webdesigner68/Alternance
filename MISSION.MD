🎯 Mission

Tu es un développeur Flutter Staff. Génère un projet Flutter complet, prêt prod, qui permet de rechercher des offres d’alternance, afficher les détails et candidater via l’API publique Apprentissage – La Bonne Alternance.

L’app doit fonctionner immédiatement avec une clé API valide (mode prod) et fournir un mode secours (legacy + mock) si la clé n’est pas encore habilitée.

🔗 API — VÉRITÉ TERRAIN (critique)

Base API prod (v2) : https://api.apprentissage.beta.gouv.fr/api
Endpoints à implémenter maintenant :

GET /job/v1/search – Recherche d’opportunités d’emploi en alternance
Paramètres pris en charge :

latitude (−90..90), longitude (−180..180) – strings 6 décimales

radius (0..200, défaut 30) – entier (pas 30.0)

romes – CSV (ex.: F1603,F1201)

rncp – ex.: RNCP34436

target_diploma_level – "3" | "4" | "5" | "6" | "7"

opco – (AFDAS, ATLAS, Constructys, L’Opcommerce, OCAPIAT, OPCO 2i, Opco Mobilités, Opco Santé, Opco entreprises de proximité, Uniformation, Opco de la cohésion sociale)

departements – paramètre répété (...&departements=75&departements=06)

partners_to_exclude – paramètre répété (exclure « France Travail », « Hellowork », etc.)
Réponse : { jobs: [...], recruiters: [...], warnings: [...] }
Tri natif : source (LBA > France Travail > autres) → distance (si geo) → date desc.

GET /job/v1/offer/{id} – Détails d’une offre

POST /job/v1/apply – Candidature in-app
Body requis :

applicant_first_name (1..50)

applicant_last_name (1..50)

applicant_email (email valide)

applicant_phone (numéro EU mobile/fixe)

applicant_attachment_name (ex.: cv.pdf)

applicant_attachment_content (Base64 du CV)

recipient_id (depuis apply.recipient_id de la recherche)

applicant_message (optionnel)
Succès attendu : HTTP 202

GET /job/v1/export – URL temporaire JSON (valable ~2 min) + lastUpdate (à implémenter côté service mais UI non prioritaire)

GET /job/v1/offer/{id}/publishing-informations – statut de publication (PUBLISHED, WILL_BE_PUBLISHED, WILL_NOT_BE_PUBLISHED) + éventuel error{ code,label } (préparer le client, même si non utilisé côté candidat)

GET /healthcheck – ping service (afficher version/env en « À propos »)

Authentification obligatoire (v2)
Utiliser UN SEUL header d’auth (ne jamais en envoyer 2 en même temps) :

Option A (recommandé) : X-Api-Key: <API_KEY>

Option B : Authorization: Api-Key <API_KEY>
Et toujours Accept: application/json.
Si 401 → clé invalide, expirée ou non habilitée. L’app doit le détecter et guider l’utilisateur pour coller une clé valide / contacter l’admin / mode secours.

Legacy (secours temporaire) – même app, code conditionnel
Host vitrine : https://labonnealternance.apprentissage.beta.gouv.fr
Endpoints historiques (lecture « jobs/entreprises susceptibles ») :

GET /api/V1/jobs avec paramètres :

caller (obligatoire) – identifiant de l’intégrateur

romes (ex.: M1805) ou rncp

latitude, longitude, radius (optionnels)
Ces routes ne demandent pas la clé v2 et servent d’affichage minimal si la clé v2 n’est pas encore activée. Marque visuelle « mode dégradé » + bandeau d’info.

🧱 Architecture & Qualité

Flutter stable, Dart null-safety, Material 3 + thèmes sombre/clair, responsive (tél. + petite tablette).

State management : Riverpod (flutter_riverpod) + go_router (deep link offre).

HTTP : Dio + interceptors (auth, retry expo GET, logging en debug).

freezed + json_serializable pour modèles immuables & mapping JSON.

Cache offline : Hive (résultats + critères, TTL configurable).

Secure storage : flutter_secure_storage (clé API, préférences sensibles).

Fichier : file_picker (CV) + encodage Base64 en mémoire (ne pas persister).

Géoloc : geolocator + permission_handler.

Carte : flutter_map (OSM).

Accessibilité : labels sémantiques, 48dp targets, contrastes AA, dynamic type.

Lints : very_good_analysis (ou flutter_lints renforcé).

Tests :

Unit : parsing, usecases, rate-limiter, validation apply

Widget : liste, détail, formulaire apply (mock 202)

Golden : OfferCard (clair/sombre), skeletons

CI GitHub Actions : analyze + test (option build debug).

📁 Arborescence attendue
lib/
  app/           (bootstrap, themes, router)
  core/          (config, env, errors, utils, rate_limiter, html_sanitizer)
  data/
    datasources/remote/ (dio client v2, dio client legacy, interceptors)
    repositories/
    models/      (freezed + json)
  domain/
    entities/
    usecases/    (SearchOffers, GetOfferDetails, ApplyToOffer, PingHealth, ExportOffers)
  features/
    search/
      presentation/ (SearchScreen, MapTab, filters)
      application/  (providers/notifiers)
    details/
    apply/
  widgets/       (OfferCard, Badges, HtmlDescription, ErrorView, Skeletons)
  l10n/
assets/
test/

🧩 Modèles (freezed) — null-safety stricte

Identifier { id, partner_label }

Location { city, postcode, lat, lon }

Workplace { name?, description?, siret?, website?, location?: Location, headcount?, sector? }

Contract { type, start_date?, duration_months?, work_mode? /* onsite|hybrid|remote */ }

Offer { title, description(html autorisé), desired_skills?: List<String>, to_be_acquired_skills?: List<String>, access_conditions?, positions?, romes?: List<String>, target_diploma_level?, status? }

Apply { url?, recipient_id? }

Job { identifier: Identifier, workplace?: Workplace, contract?: Contract, offer: Offer, apply?: Apply, is_delegated?: bool }

SearchResponse { jobs: List<Job>, recruiters: List<Map<String,dynamic>>?, warnings: List<String>? }

Description HTML : autoriser uniquement <b><i><em><strong><p><br><ul><li> (sanitizer maison).

🔐 Auth & Réseau — Interceptors obligatoires

Toujours ajouter Accept: application/json.

Un seul header d’auth (configurable) :
X-Api-Key: <clé> ou Authorization: Api-Key <clé>.

followRedirects: false + validateStatus: s < 500 (lire body en 4xx).

responseType: json et fallback si le serveur renvoie text/html (200/404 déguisés) : tenter jsonDecode si le body commence par { ou [ ; sinon lever une erreur claire avec un extrait (sample 300 chars).

Rate limiter (token bucket) configurable (1 req/s pour routes “création/màj” ; prêt mais non activé côté candidat).

🔎 Sérialisation des critères (v2)

romes → CSV (M1805,M1607)

departements → param répété

partners_to_exclude → param répété

radius → entier

lat/lon → toStringAsFixed(6)

🖥️ Écrans & UX

Onboarding / Clé API & Permissions

Écran “Configurer ma clé API” : champ texte + bouton Tester la clé

Choix du schéma d’auth : radio (X-Api-Key / Authorization: Api-Key)

Bouton « Aide / Obtenir une clé » (ouvre l’espace dev dans un CustomTab).

Si test 401 → expliquer « clé expirée / non habilitée » + lien d’assistance.

Demander géoloc (skippable) + fallback saisie ville/CP.

Switch thème sombre/clair.

Recherche (liste + carte)

Filtres : rayon (slider 0–200), niveau de diplôme, ROME (multi avec suggestions), RNCP, départements (multi), OPCO, sources à exclure.

Actions : « Autour de moi » (lat/lon) ou France entière.

Résultats : liste (OfferCard) + onglet carte (marker → détail).

Badges : contrat (Apprentissage/Pro), mode (Onsite/Hybrid/Remote), niveau diplôme.

Afficher warnings[] en bandeau info.

Détail d’une offre

Titre, partenaire/source, workplace (nom, SIRET, site, effectif, secteur).

Description (HTML restreint), compétences (attendues / à acquérir), conditions d’accès, date début, durée, ROME, RNCP, statut.

CTA “Postuler” :

Si apply.recipient_id → POST /job/v1/apply in-app

Sinon si apply.url → ouvrir navigateur (avertissement)

Candidature in-app

Formulaire avec validations (noms 1..50, email, téléphone EU).

Ajout CV (PDF/DOC/…) → lecture en mémoire → Base64 → POST /job/v1/apply.

Attendre 202 → toast succès ; sinon afficher message détaillé.

Purge immédiate des données sensibles (CV, champs) après la réponse.

Mode secours (legacy)

Si v2 → 401/403 persistant : proposer basculer en “Mode dégradé”

Appeler GET https://labonnealternance.apprentissage.beta.gouv.fr/api/V1/jobs?caller=<APP>&romes=<CSV>&latitude=...&longitude=...&radius=...

Afficher un badge « ⚠️ Données limitées (mode dégradé) ».

L’UI reste identique, mais le bouton “Postuler” ouvre l’URL externe si dispo.

À propos / Diagnostic

Ping healthcheck (v2) + afficher env/version.

Panneau Diagnostic réseau (status, content-type, redirects, extrait body si non-JSON).

⚙️ Config & Env

env.example.json

{
  "API_V2_BASE_URL": "https://api.apprentissage.beta.gouv.fr/api",
  "API_LEGACY_BASE_URL": "https://labonnealternance.apprentissage.beta.gouv.fr",
  "API_KEY_HEADER": "X-Api-Key",
  "API_KEY": "",
  "SEARCH_DEFAULT_RADIUS_KM": 30,
  "CACHE_TTL_MINUTES": 30,
  "USE_AUTHORIZATION_HEADER": false,
  "ENABLE_LEGACY_FALLBACK": true
}


Lecture via --dart-define-from-file=env.json + fallback SecureStorage.

Ne jamais commiter la clé API.

🧪 cURL de référence (docs dans le README)
# v2 — X-Api-Key
curl -i -H "Accept: application/json" \
  -H "X-Api-Key: ${LBA_API_KEY}" \
  "https://api.apprentissage.beta.gouv.fr/api/job/v1/search?latitude=48.856613&longitude=2.352222&radius=30&romes=M1805"

# v2 — Authorization: Api-Key
curl -i -H "Accept: application/json" \
  -H "Authorization: Api-Key ${LBA_API_KEY}" \
  "https://api.apprentissage.beta.gouv.fr/api/job/v1/search?latitude=48.856613&longitude=2.352222&radius=30"

🛠️ Code clé à générer (exigé)

Client Dio v2 (prod) – avec garde-fous HTML/200

responseType: ResponseType.json, followRedirects: false, validateStatus: s < 500.

Interceptor Auth : injecter un seul header (selon config).

Interceptor Content-Type Guard : si content-type ≠ JSON et data is String, tenter jsonDecode(...) si débute par {/[ ; sinon rejeter avec message Expected JSON but got <ct> + sample 300 chars.

Sérialisation v2

romes CSV

departements & partners_to_exclude répétés

radius entier

lat/lon → toStringAsFixed(6)

POST /job/v1/apply

Encoder le CV en Base64 en mémoire.

Validation côté client (longueurs, email, téléphone EU).

Accepter 202 comme succès.

Sanitizer HTML

Whitelist stricte : <b><i><em><strong><p><br><ul><li>.

Mode legacy

Second client Dio pointant https://labonnealternance.apprentissage.beta.gouv.fr.

GET /api/V1/jobs?caller=<APP>&romes=<CSV>&latitude=...&longitude=...&radius=...

Pas d’auth header v2.

Mapper résultats « au mieux » sur les entités Job; champs manquants → null.

🧰 Dépendances (suggestion)
dio, riverpod, go_router,
freezed_annotation, json_annotation, build_runner, freezed, json_serializable,
hive, hive_flutter,
geolocator, permission_handler,
file_picker, flutter_secure_storage,
intl, url_launcher, flutter_map, shimmer

🧪 Tests à livrer

Unit :

SearchOffers : génération de query v2 (CSV + répétés), radius entier

Interceptor Content-Type → lève sur text/html 200

Validations apply (noms 1..50, email, téléphone EU)

Décodage JWT utilitaire (lecture du exp, iss) pour debug UI

Widget :

Recherche (loading/data/empty/error)

Détail (HTML rendu & badges)

Apply (mock 202)

Golden : OfferCard + Skeleton (clair/sombre)

📝 README (exigé)

Installation / versions Flutter

Config env.json + explication UN SEUL header d’auth

Commandes cURL de test (v2)

Permissions Android/iOS

Mode dégradé (legacy) & limites

Captures écran (si possible)

✅ Definition of Done

V2 : Recherche OK (France entière & géolocalisée), filtres ROME/RNCP/niveau/départements/OPCO/sources exclues OK.

Détails : description HTML sécurisée, workplace affiché si dispo.

Candidature : POST /job/v1/apply → 202 traité comme succès ; purge des données sensibles juste après.

Réseau : aucun 404 HTML/200 silencieux (garde-fous actifs), un seul header d’auth, logs masqués en release.

Fallback : mode legacy opérationnel avec badge « mode dégradé » si v2 en 401/403.

Sécurité : clé non commitée, CV non persisté, bouton « effacer mes données ».

Qualité : lints OK, tests OK, UX fluide (skeletons, erreurs propres), builds Android/iOS OK.

Docs : README complet + exemples cURL.

🚫 Important

Ne pose aucune question.

Livrer tout le code, prêt à compiler et exécuter.

Respecter à la lettre la config réseau, les headers, la sérialisation, le fallback, les validations et la purge des données sensibles.
