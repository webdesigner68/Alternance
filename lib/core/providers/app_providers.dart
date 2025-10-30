import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../../data/datasources/remote/dio_client_v2.dart';
import '../../data/datasources/remote/dio_client_legacy.dart';
import '../../data/datasources/remote/job_remote_datasource.dart';
import '../../data/datasources/remote/job_legacy_datasource.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../domain/repositories/job_repository.dart';
import '../../domain/usecases/search_offers.dart';
import '../../domain/usecases/get_offer_details.dart';
import '../../domain/usecases/apply_to_offer.dart';
import '../../domain/usecases/ping_health.dart';

final appConfigProvider = FutureProvider<AppConfig>((ref) async {
  return AppConfig.load();
});

final dioClientV2Provider = Provider<DioClientV2>((ref) {
  final config = ref.watch(appConfigProvider).value;
  if (config == null) {
    throw Exception('AppConfig not loaded');
  }
  return DioClientV2(config);
});

final dioClientLegacyProvider = Provider<DioClientLegacy>((ref) {
  final config = ref.watch(appConfigProvider).value;
  if (config == null) {
    throw Exception('AppConfig not loaded');
  }
  return DioClientLegacy(config);
});

final jobRemoteDatasourceProvider = Provider<JobRemoteDatasource>((ref) {
  final client = ref.watch(dioClientV2Provider);
  return JobRemoteDatasource(client);
});

final jobLegacyDatasourceProvider = Provider<JobLegacyDatasource>((ref) {
  final client = ref.watch(dioClientLegacyProvider);
  return JobLegacyDatasource(client);
});

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final remoteDatasource = ref.watch(jobRemoteDatasourceProvider);
  final legacyDatasource = ref.watch(jobLegacyDatasourceProvider);
  return JobRepositoryImpl(
    remoteDatasource: remoteDatasource,
    legacyDatasource: legacyDatasource,
  );
});

final searchOffersUseCaseProvider = Provider<SearchOffersUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return SearchOffersUseCase(repository);
});

final getOfferDetailsUseCaseProvider = Provider<GetOfferDetailsUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return GetOfferDetailsUseCase(repository);
});

final applyToOfferUseCaseProvider = Provider<ApplyToOfferUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return ApplyToOfferUseCase(repository);
});

final pingHealthUseCaseProvider = Provider<PingHealthUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return PingHealthUseCase(repository);
});
