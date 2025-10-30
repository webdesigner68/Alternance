import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../models/search_criteria.dart';
import '../../models/job.dart';
import '../../models/identifier.dart';
import '../../models/offer.dart';
import '../../models/apply.dart';
import '../../models/workplace.dart';
import '../../models/location.dart';
import 'dio_client_legacy.dart';

class JobLegacyDatasource {
  JobLegacyDatasource(this.client);

  final DioClientLegacy client;

  Future<List<Job>> searchJobs(SearchCriteria criteria) async {
    try {
      final queryParams = _buildSearchQuery(criteria);
      
      final response = await client.dio.get<Map<String, dynamic>>(
        '/api/V1/jobs',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) {
        throw Failure.network(
          message: 'Erreur lors de la recherche (mode dégradé)',
          statusCode: response.statusCode,
        );
      }

      // Legacy API returns different structure
      // Try to map to our Job model as best as possible
      final data = response.data;
      if (data == null) return [];

      final results = data['results'] as List<dynamic>? ?? 
                     data['jobs'] as List<dynamic>? ?? 
                     [];

      return results
          .map((json) => _mapLegacyToJob(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Failure.network(
        message: e.message ?? 'Erreur réseau (mode dégradé)',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Map<String, dynamic> _buildSearchQuery(SearchCriteria criteria) {
    final query = <String, dynamic>{
      'caller': 'LBA_FLUTTER_APP',
    };

    if (criteria.romes != null && criteria.romes!.isNotEmpty) {
      query['romes'] = criteria.romes!.join(',');
    }

    if (criteria.rncp != null) {
      query['rncp'] = criteria.rncp;
    }

    if (criteria.latitude != null) {
      query['latitude'] = criteria.latitude!.toStringAsFixed(6);
    }
    if (criteria.longitude != null) {
      query['longitude'] = criteria.longitude!.toStringAsFixed(6);
    }
    if (criteria.latitude != null || criteria.longitude != null) {
      query['radius'] = criteria.radius;
    }

    return query;
  }

  Job _mapLegacyToJob(Map<String, dynamic> json) {
    // Best-effort mapping from legacy structure
    return Job(
      identifier: Identifier(
        id: json['id']?.toString() ?? json['ideaId']?.toString() ?? '',
        partnerLabel: json['company']?.toString() ?? 'Legacy',
      ),
      workplace: Workplace(
        name: json['title']?.toString() ?? json['company']?.toString(),
        siret: json['siret']?.toString(),
        location: Location(
          city: json['city']?.toString(),
          postcode: json['zip']?.toString(),
          lat: _parseDouble(json['lat']),
          lon: _parseDouble(json['lon']),
        ),
      ),
      offer: Offer(
        title: json['title']?.toString() ?? 'Offre',
        description: json['description']?.toString(),
        romes: json['romes'] != null 
            ? [json['romes'].toString()] 
            : null,
      ),
      apply: Apply(
        url: json['url']?.toString(),
      ),
    );
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
