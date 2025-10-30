import 'package:flutter/foundation.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/remote/job_remote_datasource.dart';
import '../datasources/remote/job_legacy_datasource.dart';
import '../models/apply_request.dart';
import '../models/health_check.dart';
import '../models/search_criteria.dart';
import '../models/search_response.dart';
import '../models/job.dart';

class JobRepositoryImpl implements JobRepository {
  JobRepositoryImpl({
    required this.remoteDatasource,
    required this.legacyDatasource,
  });

  final JobRemoteDatasource remoteDatasource;
  final JobLegacyDatasource legacyDatasource;
  bool _useLegacyMode = false;

  @override
  Future<SearchResponse> searchJobs(SearchCriteria criteria) async {
    if (_useLegacyMode) {
      return _searchJobsLegacy(criteria);
    }

    try {
      return await remoteDatasource.searchJobs(criteria);
    } on Failure catch (e) {
      if (e is UnauthorizedFailure) {
        debugPrint('Unauthorized, switching to legacy mode');
        _useLegacyMode = true;
        return _searchJobsLegacy(criteria);
      }
      rethrow;
    }
  }

  Future<SearchResponse> _searchJobsLegacy(SearchCriteria criteria) async {
    final jobs = await legacyDatasource.searchJobs(criteria);
    return SearchResponse(
      jobs: jobs,
      warnings: [
        '⚠️ Mode dégradé : données limitées. Activez votre clé API v2 pour '
            'accéder à toutes les fonctionnalités.',
      ],
    );
  }

  @override
  Future<Job> getOfferDetails(String offerId) async {
    if (_useLegacyMode) {
      throw const Failure.unknown(
        message: 'Détails non disponibles en mode dégradé',
      );
    }

    return remoteDatasource.getOfferDetails(offerId);
  }

  @override
  Future<void> applyToOffer(ApplyRequest request) async {
    if (_useLegacyMode) {
      throw const Failure.unknown(
        message: 'Candidature en ligne non disponible en mode dégradé',
      );
    }

    return remoteDatasource.applyToOffer(request);
  }

  @override
  Future<HealthCheck> healthCheck() async {
    return remoteDatasource.healthCheck();
  }

  @override
  bool get isLegacyMode => _useLegacyMode;

  @override
  void setLegacyMode(bool enabled) {
    _useLegacyMode = enabled;
  }
}
