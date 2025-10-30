import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../models/apply_request.dart';
import '../../models/health_check.dart';
import '../../models/search_criteria.dart';
import '../../models/search_response.dart';
import '../../models/job.dart';
import 'dio_client_v2.dart';

class JobRemoteDatasource {
  JobRemoteDatasource(this.client);

  final DioClientV2 client;

  Future<SearchResponse> searchJobs(SearchCriteria criteria) async {
    try {
      final queryParams = _buildSearchQuery(criteria);
      
      final response = await client.dio.get<Map<String, dynamic>>(
        '/job/v1/search',
        queryParameters: queryParams,
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const Failure.unauthorized(
          message: 'Clé API invalide, expirée ou non habilitée',
        );
      }

      if (response.statusCode != 200) {
        throw Failure.network(
          message: 'Erreur lors de la recherche',
          statusCode: response.statusCode,
          responseBody: response.data?.toString(),
        );
      }

      return SearchResponse.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw e.error as Failure;
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw const Failure.unauthorized(
          message: 'Clé API invalide, expirée ou non habilitée',
        );
      }
      throw Failure.network(
        message: e.message ?? 'Erreur réseau',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Map<String, dynamic> _buildSearchQuery(SearchCriteria criteria) {
    final query = <String, dynamic>{};

    if (criteria.latitude != null) {
      query['latitude'] = criteria.latitude!.toStringAsFixed(6);
    }
    if (criteria.longitude != null) {
      query['longitude'] = criteria.longitude!.toStringAsFixed(6);
    }
    
    query['radius'] = criteria.radius;

    if (criteria.romes != null && criteria.romes!.isNotEmpty) {
      query['romes'] = criteria.romes!.join(',');
    }

    if (criteria.rncp != null) {
      query['rncp'] = criteria.rncp;
    }

    if (criteria.targetDiplomaLevel != null) {
      query['target_diploma_level'] = criteria.targetDiplomaLevel;
    }

    if (criteria.opco != null) {
      query['opco'] = criteria.opco;
    }

    // Repeated parameters: departements
    if (criteria.departements != null && criteria.departements!.isNotEmpty) {
      for (final dept in criteria.departements!) {
        if (!query.containsKey('departements')) {
          query['departements'] = [];
        }
        (query['departements'] as List).add(dept);
      }
    }

    // Repeated parameters: partners_to_exclude
    if (criteria.partnersToExclude != null && 
        criteria.partnersToExclude!.isNotEmpty) {
      for (final partner in criteria.partnersToExclude!) {
        if (!query.containsKey('partners_to_exclude')) {
          query['partners_to_exclude'] = [];
        }
        (query['partners_to_exclude'] as List).add(partner);
      }
    }

    return query;
  }

  Future<Job> getOfferDetails(String offerId) async {
    try {
      final response = await client.dio.get<Map<String, dynamic>>(
        '/job/v1/offer/$offerId',
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const Failure.unauthorized(
          message: 'Clé API invalide',
        );
      }

      if (response.statusCode == 404) {
        throw const Failure.notFound(
          message: 'Offre non trouvée',
        );
      }

      if (response.statusCode != 200) {
        throw Failure.network(
          message: 'Erreur lors de la récupération des détails',
          statusCode: response.statusCode,
        );
      }

      return Job.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw e.error as Failure;
      }
      throw Failure.network(
        message: e.message ?? 'Erreur réseau',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> applyToOffer(ApplyRequest request) async {
    try {
      final response = await client.dio.post<void>(
        '/job/v1/apply',
        data: request.toJson(),
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const Failure.unauthorized(
          message: 'Clé API invalide',
        );
      }

      // Accept 202 as success
      if (response.statusCode != 202 && response.statusCode != 200) {
        throw Failure.network(
          message: 'Erreur lors de la candidature',
          statusCode: response.statusCode,
          responseBody: response.data?.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw e.error as Failure;
      }
      throw Failure.network(
        message: e.message ?? 'Erreur réseau',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<HealthCheck> healthCheck() async {
    try {
      final response = await client.dio.get<Map<String, dynamic>>(
        '/healthcheck',
      );

      if (response.statusCode != 200) {
        throw Failure.network(
          message: 'Service indisponible',
          statusCode: response.statusCode,
        );
      }

      return HealthCheck.fromJson(response.data!);
    } on DioException catch (e) {
      throw Failure.network(
        message: e.message ?? 'Erreur réseau',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
