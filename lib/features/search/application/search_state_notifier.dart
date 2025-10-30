import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/failures.dart';
import '../../../core/providers/app_providers.dart';
import '../../../data/models/search_criteria.dart';
import '../../../data/models/search_response.dart';

class SearchState {
  SearchState({
    this.isLoading = false,
    this.response,
    this.failure,
    this.criteria = const SearchCriteria(),
  });

  final bool isLoading;
  final SearchResponse? response;
  final Failure? failure;
  final SearchCriteria criteria;

  SearchState copyWith({
    bool? isLoading,
    SearchResponse? response,
    Failure? failure,
    SearchCriteria? criteria,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      failure: failure,
      criteria: criteria ?? this.criteria,
    );
  }

  SearchState clearError() {
    return SearchState(
      isLoading: isLoading,
      response: response,
      failure: null,
      criteria: criteria,
    );
  }
}

class SearchStateNotifier extends StateNotifier<SearchState> {
  SearchStateNotifier(this.ref) : super(SearchState());

  final Ref ref;

  Future<void> search(SearchCriteria criteria) async {
    state = state.copyWith(isLoading: true, criteria: criteria);

    try {
      final useCase = ref.read(searchOffersUseCaseProvider);
      final response = await useCase(criteria);
      state = state.copyWith(
        isLoading: false,
        response: response,
        failure: null,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: Failure.unknown(
          message: 'Erreur inattendue',
          error: e,
        ),
      );
    }
  }

  void updateCriteria(SearchCriteria criteria) {
    state = state.copyWith(criteria: criteria);
  }

  void clearError() {
    state = state.clearError();
  }
}

final searchStateProvider =
    StateNotifierProvider<SearchStateNotifier, SearchState>((ref) {
  return SearchStateNotifier(ref);
});
