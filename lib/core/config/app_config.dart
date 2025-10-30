import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfig {
  AppConfig._({
    required this.apiV2BaseUrl,
    required this.apiLegacyBaseUrl,
    required this.apiKeyHeader,
    required this.apiKey,
    required this.searchDefaultRadiusKm,
    required this.cacheTtlMinutes,
    required this.useAuthorizationHeader,
    required this.enableLegacyFallback,
  });

  final String apiV2BaseUrl;
  final String apiLegacyBaseUrl;
  final String apiKeyHeader;
  final String apiKey;
  final int searchDefaultRadiusKm;
  final int cacheTtlMinutes;
  final bool useAuthorizationHeader;
  final bool enableLegacyFallback;

  static AppConfig? _instance;
  static const _storage = FlutterSecureStorage();

  static Future<AppConfig> load() async {
    if (_instance != null) return _instance!;

    // Try to load from --dart-define-from-file
    String? configJson;
    try {
      configJson = const String.fromEnvironment('CONFIG_JSON');
    } catch (_) {}

    Map<String, dynamic> config = {};

    if (configJson != null && configJson.isNotEmpty) {
      config = jsonDecode(configJson) as Map<String, dynamic>;
    } else {
      // Try to load from asset (fallback)
      try {
        final jsonString = await rootBundle.loadString('env.json');
        config = jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (_) {
        // Use defaults
      }
    }

    // Load API key from secure storage if not provided
    String apiKey = config['API_KEY'] as String? ?? '';
    if (apiKey.isEmpty) {
      apiKey = await _storage.read(key: 'api_key') ?? '';
    }

    _instance = AppConfig._(
      apiV2BaseUrl: config['API_V2_BASE_URL'] as String? ??
          'https://api.apprentissage.beta.gouv.fr/api',
      apiLegacyBaseUrl: config['API_LEGACY_BASE_URL'] as String? ??
          'https://labonnealternance.apprentissage.beta.gouv.fr',
      apiKeyHeader: config['API_KEY_HEADER'] as String? ?? 'X-Api-Key',
      apiKey: apiKey,
      searchDefaultRadiusKm: config['SEARCH_DEFAULT_RADIUS_KM'] as int? ?? 30,
      cacheTtlMinutes: config['CACHE_TTL_MINUTES'] as int? ?? 30,
      useAuthorizationHeader:
          config['USE_AUTHORIZATION_HEADER'] as bool? ?? false,
      enableLegacyFallback:
          config['ENABLE_LEGACY_FALLBACK'] as bool? ?? true,
    );

    return _instance!;
  }

  Future<void> updateApiKey(String newKey) async {
    await _storage.write(key: 'api_key', value: newKey);
    _instance = AppConfig._(
      apiV2BaseUrl: apiV2BaseUrl,
      apiLegacyBaseUrl: apiLegacyBaseUrl,
      apiKeyHeader: apiKeyHeader,
      apiKey: newKey,
      searchDefaultRadiusKm: searchDefaultRadiusKm,
      cacheTtlMinutes: cacheTtlMinutes,
      useAuthorizationHeader: useAuthorizationHeader,
      enableLegacyFallback: enableLegacyFallback,
    );
  }

  Future<void> updateAuthHeaderType(bool useAuthorization) async {
    await _storage.write(
      key: 'use_authorization_header',
      value: useAuthorization.toString(),
    );
    _instance = AppConfig._(
      apiV2BaseUrl: apiV2BaseUrl,
      apiLegacyBaseUrl: apiLegacyBaseUrl,
      apiKeyHeader: apiKeyHeader,
      apiKey: apiKey,
      searchDefaultRadiusKm: searchDefaultRadiusKm,
      cacheTtlMinutes: cacheTtlMinutes,
      useAuthorizationHeader: useAuthorization,
      enableLegacyFallback: enableLegacyFallback,
    );
  }

  String get authHeaderName {
    if (useAuthorizationHeader) {
      return 'Authorization';
    }
    return apiKeyHeader;
  }

  String get authHeaderValue {
    if (useAuthorizationHeader) {
      return 'Api-Key $apiKey';
    }
    return apiKey;
  }
}
