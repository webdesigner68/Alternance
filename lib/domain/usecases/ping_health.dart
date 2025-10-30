import '../../data/models/health_check.dart';
import '../repositories/job_repository.dart';

class PingHealthUseCase {
  PingHealthUseCase(this.repository);

  final JobRepository repository;

  Future<HealthCheck> call() async {
    return repository.healthCheck();
  }
}
