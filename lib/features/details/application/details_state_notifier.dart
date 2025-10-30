import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/failures.dart';
import '../../../core/providers/app_providers.dart';
import '../../../data/models/job.dart';

class DetailsState {
  DetailsState({
    this.isLoading = false,
    this.job,
    this.failure,
  });

  final bool isLoading;
  final Job? job;
  final Failure? failure;

  DetailsState copyWith({
    bool? isLoading,
    Job? job,
    Failure? failure,
  }) {
    return DetailsState(
      isLoading: isLoading ?? this.isLoading,
      job: job ?? this.job,
      failure: failure,
    );
  }
}

class DetailsStateNotifier extends StateNotifier<DetailsState> {
  DetailsStateNotifier(this.ref) : super(DetailsState());

  final Ref ref;

  Future<void> loadDetails(String offerId) async {
    state = state.copyWith(isLoading: true);

    try {
      final useCase = ref.read(getOfferDetailsUseCaseProvider);
      final job = await useCase(offerId);
      state = state.copyWith(
        isLoading: false,
        job: job,
        failure: null,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    }
  }
}

final detailsStateProvider =
    StateNotifierProvider.family<DetailsStateNotifier, DetailsState, String>(
  (ref, offerId) {
    final notifier = DetailsStateNotifier(ref);
    notifier.loadDetails(offerId);
    return notifier;
  },
);
