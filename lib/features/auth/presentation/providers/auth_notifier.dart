import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/authenticate_user.dart';
import '../../domain/usecases/check_authentication.dart';
import '../../domain/usecases/logout_user.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserEntity? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserEntity? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthenticateUser _authenticateUser;
  final CheckAuthentication _checkAuthentication;
  final LogoutUser _logoutUser;

  AuthNotifier(
    this._authenticateUser,
    this._checkAuthentication,
    this._logoutUser,
  ) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isAuthenticated = await _checkAuthentication();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: isAuthenticated,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error verificando autenticación',
      );
    }
  }

  Future<bool> authenticate(String code) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _authenticateUser(code);

      if (success) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Código de acceso inválido',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error de autenticación',
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _logoutUser();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cerrar sesión',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    sl<AuthenticateUser>(),
    sl<CheckAuthentication>(),
    sl<LogoutUser>(),
  );
});
