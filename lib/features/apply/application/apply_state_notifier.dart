import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/failures.dart';
import '../../../core/providers/app_providers.dart';
import '../../../data/models/apply_request.dart';

class ApplyState {
  ApplyState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.failure,
  });

  final bool isSubmitting;
  final bool isSuccess;
  final Failure? failure;

  ApplyState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    Failure? failure,
  }) {
    return ApplyState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: failure,
    );
  }
}

class ApplyStateNotifier extends StateNotifier<ApplyState> {
  ApplyStateNotifier(this.ref) : super(ApplyState());

  final Ref ref;

  Future<void> submit(ApplyRequest request) async {
    state = state.copyWith(isSubmitting: true);

    try {
      final useCase = ref.read(applyToOfferUseCaseProvider);
      await useCase(request);
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        failure: null,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        failure: e,
      );
    }
  }

  void reset() {
    state = ApplyState();
  }
}

final applyStateProvider =
    StateNotifierProvider<ApplyStateNotifier, ApplyState>((ref) {
  return ApplyStateNotifier(ref);
});
