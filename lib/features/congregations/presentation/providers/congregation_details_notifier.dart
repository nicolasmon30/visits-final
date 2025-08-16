import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/congregation_details_entity.dart';
import '../../domain/usecases/congregations_usecases.dart';

class CongregationDetailsState {
  final bool isLoading;
  final bool isSaving;
  final CongregationDetailsEntity? details;
  final String? error;

  const CongregationDetailsState({
    this.isLoading = false,
    this.isSaving = false,
    this.details,
    this.error,
  });

  CongregationDetailsState copyWith({
    bool? isLoading,
    bool? isSaving,
    CongregationDetailsEntity? details,
    String? error,
  }) {
    return CongregationDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      details: details ?? this.details,
      error: error,
    );
  }
}

class CongregationDetailsNotifier
    extends StateNotifier<CongregationDetailsState> {
  final GetCongregationDetails _getCongregationDetails;
  final SaveCongregationDetails _saveCongregationDetails;

  CongregationDetailsNotifier(
    this._getCongregationDetails,
    this._saveCongregationDetails,
  ) : super(const CongregationDetailsState());

  Future<void> loadDetails(String congregationId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final details = await _getCongregationDetails(congregationId);
      state = state.copyWith(
        isLoading: false,
        details: details ?? CongregationDetailsEntity.empty(congregationId),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando detalles de la congregación',
      );
    }
  }

  Future<bool> saveDetails(CongregationDetailsEntity details) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final success = await _saveCongregationDetails(details);

      if (success) {
        state = state.copyWith(
          isSaving: false,
          details: details,
        );
        return true;
      } else {
        state = state.copyWith(
          isSaving: false,
          error: 'Error guardando detalles',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Error inesperado al guardar detalles',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final congregationDetailsNotifierProvider = StateNotifierProvider<
    CongregationDetailsNotifier, CongregationDetailsState>((ref) {
  return CongregationDetailsNotifier(
    sl<GetCongregationDetails>(),
    sl<SaveCongregationDetails>(),
  );
});
