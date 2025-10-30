import '../../data/models/apply_request.dart';
import '../../data/models/health_check.dart';
import '../../data/models/search_criteria.dart';
import '../../data/models/search_response.dart';
import '../../data/models/job.dart';

abstract class JobRepository {
  Future<SearchResponse> searchJobs(SearchCriteria criteria);
  Future<Job> getOfferDetails(String offerId);
  Future<void> applyToOffer(ApplyRequest request);
  Future<HealthCheck> healthCheck();
  bool get isLegacyMode;
  void setLegacyMode(bool enabled);
}
