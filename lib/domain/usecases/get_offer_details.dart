import '../../data/models/job.dart';
import '../repositories/job_repository.dart';

class GetOfferDetailsUseCase {
  GetOfferDetailsUseCase(this.repository);

  final JobRepository repository;

  Future<Job> call(String offerId) async {
    return repository.getOfferDetails(offerId);
  }
}
