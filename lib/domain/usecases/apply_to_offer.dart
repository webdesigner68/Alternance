import '../../data/models/apply_request.dart';
import '../repositories/job_repository.dart';

class ApplyToOfferUseCase {
  ApplyToOfferUseCase(this.repository);

  final JobRepository repository;

  Future<void> call(ApplyRequest request) async {
    return repository.applyToOffer(request);
  }
}
