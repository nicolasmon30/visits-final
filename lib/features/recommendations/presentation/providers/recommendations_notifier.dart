import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/usecases/recommendations_usecases.dart';

class RecommendationsState {
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final List<RecommendationEntity> recommendations;
  final String? error;
  final String? currentCongregationId;

  const RecommendationsState({
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.recommendations = const [],
    this.error,
    this.currentCongregationId,
  });

  RecommendationsState copyWith({
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    List<RecommendationEntity>? recommendations,
    String? error,
    String? currentCongregationId,
  }) {
    return RecommendationsState(
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      recommendations: recommendations ?? this.recommendations,
      error: error,
      currentCongregationId:
          currentCongregationId ?? this.currentCongregationId,
    );
  }
}

class RecommendationsNotifier extends StateNotifier<RecommendationsState> {
  final GetRecommendationsByCongregation _getRecommendationsByCongregation;
  final CreateRecommendation _createRecommendation;
  final UpdateRecommendation _updateRecommendation;
  final DeleteRecommendation _deleteRecommendation;
  final GetRecommendationsCount _getRecommendationsCount;

  RecommendationsNotifier(
    this._getRecommendationsByCongregation,
    this._createRecommendation,
    this._updateRecommendation,
    this._deleteRecommendation,
    this._getRecommendationsCount,
  ) : super(const RecommendationsState());

  Future<void> loadRecommendations(String congregationId) async {
    // Si estamos cargando una congregación diferente, resetear el estado
    if (state.currentCongregationId != congregationId) {
      state = const RecommendationsState();
      await Future.delayed(const Duration(milliseconds: 50));
    }
    if (state.isLoading && state.currentCongregationId == congregationId) {
      print('Already loading recommendations for this congregation');
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentCongregationId: congregationId,
    );

    try {
      print('Fetching recommendations from repository...');
      final recommendations =
          await _getRecommendationsByCongregation(congregationId);

      print('Found ${recommendations.length} recommendations');
      if (state.currentCongregationId == congregationId) {
        state = state.copyWith(
          isLoading: false,
          recommendations: recommendations,
          currentCongregationId: congregationId,
        );
      }
    } catch (e) {
      if (state.currentCongregationId == congregationId) {
        state = state.copyWith(
          isLoading: false,
          error: 'Error cargando recomendaciones',
          currentCongregationId: congregationId,
        );
      }
    }
  }

  Future<bool> createRecommendation({
    required String congregationId,
    required String titulo,
    required TipoRecomendacion tipo,
    required int edad,
    required int anosBautizado,
    required bool censurado,
    DateTime? fechaCensurado,
    required bool sacado,
    DateTime? fechaSacado,
    String? comentarios,
  }) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final success = await _createRecommendation(
        congregationId: congregationId,
        titulo: titulo,
        tipo: tipo,
        edad: edad,
        anosBautizado: anosBautizado,
        censurado: censurado,
        fechaCensurado: fechaCensurado,
        sacado: sacado,
        fechaSacado: fechaSacado,
        comentarios: comentarios,
      );

      if (success) {
        if (state.currentCongregationId == congregationId) {
          await loadRecommendations(congregationId); // Recargar la lista
        }
        state = state.copyWith(isCreating: false);
        return true;
      } else {
        state = state.copyWith(
          isCreating: false,
          error: 'Error creando recomendación',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: 'Error inesperado al crear recomendación',
      );
      return false;
    }
  }

  Future<bool> updateRecommendation(RecommendationEntity recommendation) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      final success = await _updateRecommendation(recommendation);

      if (success) {
        if (state.currentCongregationId == recommendation.congregationId) {
          await loadRecommendations(
              recommendation.congregationId); // Recargar la lista
        }
        state = state.copyWith(isUpdating: false);
        return true;
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: 'Error actualizando recomendación',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Error inesperado al actualizar recomendación',
      );
      return false;
    }
  }

  Future<bool> deleteRecommendation(String id, String congregationId) async {
    state = state.copyWith(isDeleting: true, error: null);

    try {
      final success = await _deleteRecommendation(id);

      if (success) {
        if (state.currentCongregationId == congregationId) {
          await loadRecommendations(congregationId); // Recargar la lista
        }
        state = state.copyWith(isDeleting: false);
        return true;
      } else {
        state = state.copyWith(
          isDeleting: false,
          error: 'Error eliminando recomendación',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'Error inesperado al eliminar recomendación',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearState() {
    state = const RecommendationsState();
  }
}

final recommendationsNotifierProvider =
    StateNotifierProvider<RecommendationsNotifier, RecommendationsState>((ref) {
  return RecommendationsNotifier(
    sl<GetRecommendationsByCongregation>(),
    sl<CreateRecommendation>(),
    sl<UpdateRecommendation>(),
    sl<DeleteRecommendation>(),
    sl<GetRecommendationsCount>(),
  );
});
