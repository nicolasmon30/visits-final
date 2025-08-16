import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/congregation_entity.dart';
import '../../domain/usecases/congregations_usecases.dart';

class CongregationsState {
  final bool isLoading;
  final List<CongregationEntity> congregations;
  final String? error;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  const CongregationsState({
    this.isLoading = false,
    this.congregations = const [],
    this.error,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  CongregationsState copyWith({
    bool? isLoading,
    List<CongregationEntity>? congregations,
    String? error,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return CongregationsState(
      isLoading: isLoading ?? this.isLoading,
      congregations: congregations ?? this.congregations,
      error: error,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

class CongregationsNotifier extends StateNotifier<CongregationsState> {
  final GetAllCongregations _getAllCongregations;
  final CreateCongregation _createCongregation;
  final UpdateCongregation _updateCongregation;
  final DeleteCongregation _deleteCongregation;
  final GetCongregationsCount _getCongregationsCount;

  CongregationsNotifier(
    this._getAllCongregations,
    this._createCongregation,
    this._updateCongregation,
    this._deleteCongregation,
    this._getCongregationsCount,
  ) : super(const CongregationsState());

  Future<void> loadCongregations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final congregations = await _getAllCongregations();
      state = state.copyWith(
        isLoading: false,
        congregations: congregations,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando congregaciones',
      );
    }
  }

  Future<bool> createCongregation({required String nombre}) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final success = await _createCongregation(nombre: nombre);

      if (success) {
        await loadCongregations(); // Recargar la lista
        state = state.copyWith(isCreating: false);
        return true;
      } else {
        state = state.copyWith(
          isCreating: false,
          error:
              'Error creando congregación. Verifique que el nombre no esté repetido.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: 'Error inesperado al crear congregación',
      );
      return false;
    }
  }

  Future<bool> updateCongregation(CongregationEntity congregation) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      final success = await _updateCongregation(congregation);

      if (success) {
        await loadCongregations(); // Recargar la lista
        state = state.copyWith(isUpdating: false);
        return true;
      } else {
        state = state.copyWith(
          isUpdating: false,
          error:
              'Error actualizando congregación. Verifique que el nombre no esté repetido.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Error inesperado al actualizar congregación',
      );
      return false;
    }
  }

  Future<bool> deleteCongregation(String id) async {
    state = state.copyWith(isDeleting: true, error: null);

    try {
      final success = await _deleteCongregation(id);

      if (success) {
        await loadCongregations(); // Recargar la lista
        state = state.copyWith(isDeleting: false);
        return true;
      } else {
        state = state.copyWith(
          isDeleting: false,
          error: 'Error eliminando congregación',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'Error inesperado al eliminar congregación',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final congregationsNotifierProvider =
    StateNotifierProvider<CongregationsNotifier, CongregationsState>((ref) {
  return CongregationsNotifier(
    sl<GetAllCongregations>(),
    sl<CreateCongregation>(),
    sl<UpdateCongregation>(),
    sl<DeleteCongregation>(),
    sl<GetCongregationsCount>(),
  );
});
