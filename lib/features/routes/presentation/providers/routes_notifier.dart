import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/usecases/routes_usecases.dart';

class RoutesState {
  final bool isLoading;
  final List<RouteEntity> routes;
  final String? error;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  const RoutesState({
    this.isLoading = false,
    this.routes = const [],
    this.error,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  RoutesState copyWith({
    bool? isLoading,
    List<RouteEntity>? routes,
    String? error,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return RoutesState(
      isLoading: isLoading ?? this.isLoading,
      routes: routes ?? this.routes,
      error: error,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

class RoutesNotifier extends StateNotifier<RoutesState> {
  final GetAllRoutes _getAllRoutes;
  final CreateRoute _createRoute;
  final UpdateRoute _updateRoute;
  final DeleteRoute _deleteRoute;
  final GetRoutesCount _getRoutesCount;

  RoutesNotifier(
    this._getAllRoutes,
    this._createRoute,
    this._updateRoute,
    this._deleteRoute,
    this._getRoutesCount,
  ) : super(const RoutesState());

  Future<void> loadRoutes() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final routes = await _getAllRoutes();
      state = state.copyWith(
        isLoading: false,
        routes: routes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando rutas',
      );
    }
  }

  Future<bool> createRoute({
    required String actividad,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required bool jw,
    required bool aviso,
    required bool agenda,
    String? detalles,
  }) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final success = await _createRoute(
        actividad: actividad,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        jw: jw,
        aviso: aviso,
        agenda: agenda,
        detalles: detalles,
      );

      if (success) {
        await loadRoutes(); // Recargar la lista
        state = state.copyWith(isCreating: false);
        return true;
      } else {
        state = state.copyWith(
          isCreating: false,
          error: 'Error creando ruta',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: 'Error inesperado al crear ruta',
      );
      return false;
    }
  }

  Future<bool> updateRoute(RouteEntity route) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      final success = await _updateRoute(route);

      if (success) {
        await loadRoutes(); // Recargar la lista
        state = state.copyWith(isUpdating: false);
        return true;
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: 'Error actualizando ruta',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Error inesperado al actualizar ruta',
      );
      return false;
    }
  }

  Future<bool> deleteRoute(String id) async {
    state = state.copyWith(isDeleting: true, error: null);

    try {
      final success = await _deleteRoute(id);

      if (success) {
        await loadRoutes(); // Recargar la lista
        state = state.copyWith(isDeleting: false);
        return true;
      } else {
        state = state.copyWith(
          isDeleting: false,
          error: 'Error eliminando ruta',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'Error inesperado al eliminar ruta',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final routesNotifierProvider =
    StateNotifierProvider<RoutesNotifier, RoutesState>((ref) {
  return RoutesNotifier(
    sl<GetAllRoutes>(),
    sl<CreateRoute>(),
    sl<UpdateRoute>(),
    sl<DeleteRoute>(),
    sl<GetRoutesCount>(),
  );
});
