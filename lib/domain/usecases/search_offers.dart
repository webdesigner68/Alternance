import '../../data/models/search_criteria.dart';
import '../../data/models/search_response.dart';
import '../repositories/job_repository.dart';

class SearchOffersUseCase {
  SearchOffersUseCase(this.repository);

  final JobRepository repository;

  Future<SearchResponse> call(SearchCriteria criteria) async {
    return repository.searchJobs(criteria);
  }
}
