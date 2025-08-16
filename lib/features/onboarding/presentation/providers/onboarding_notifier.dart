import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../../auth/domain/usecases/setup_user_profile.dart';

class OnboardingState {
  final bool isLoading;
  final bool isCompleted;
  final String? error;

  const OnboardingState({
    this.isLoading = false,
    this.isCompleted = false,
    this.error,
  });

  OnboardingState copyWith({
    bool? isLoading,
    bool? isCompleted,
    String? error,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final SetupUserProfile _setupUserProfile;

  OnboardingNotifier(this._setupUserProfile) : super(const OnboardingState());

  Future<bool> completeSetup({
    required String firstName,
    required String lastName,
    required String nickname,
    required String accessCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _setupUserProfile(
        firstName: firstName,
        lastName: lastName,
        nickname: nickname,
        accessCode: accessCode,
      );

      if (success) {
        state = state.copyWith(
          isLoading: false,
          isCompleted: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Error al configurar el perfil',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error inesperado durante la configuración',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(
    sl<SetupUserProfile>(),
  );
});
