import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/assembly_entity.dart';
import '../../domain/usecases/assemblies_usecases.dart';

class AssembliesState {
  final bool isLoading;
  final List<AssemblyEntity> assemblies;
  final String? error;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  const AssembliesState({
    this.isLoading = false,
    this.assemblies = const [],
    this.error,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  AssembliesState copyWith({
    bool? isLoading,
    List<AssemblyEntity>? assemblies,
    String? error,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return AssembliesState(
      isLoading: isLoading ?? this.isLoading,
      assemblies: assemblies ?? this.assemblies,
      error: error,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

class AssembliesNotifier extends StateNotifier<AssembliesState> {
  final GetAllAssemblies _getAllAssemblies;
  final CreateAssembly _createAssembly;
  final UpdateAssembly _updateAssembly;
  final DeleteAssembly _deleteAssembly;
  final GetAssembliesCount _getAssembliesCount;

  AssembliesNotifier(
    this._getAllAssemblies,
    this._createAssembly,
    this._updateAssembly,
    this._deleteAssembly,
    this._getAssembliesCount,
  ) : super(const AssembliesState());

  Future<void> loadAssemblies() async {
    print('🏛️ Loading assemblies...');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final assemblies = await _getAllAssemblies();
      print('✅ Loaded ${assemblies.length} assemblies');
      state = state.copyWith(
        isLoading: false,
        assemblies: assemblies,
      );
    } catch (e) {
      print('💥 Error loading assemblies: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando asambleas',
      );
    }
  }

  Future<bool> createAssembly({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
  }) async {
    if (state.isCreating) {
      print('⚠️ Already creating an assembly');
      return false;
    }

    print('🏛️ Creating assembly: $nombre');
    state = state.copyWith(isCreating: true, error: null);

    try {
      final success = await _createAssembly(
        nombre: nombre,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        lugar: lugar,
      );

      if (success) {
        print('✅ Assembly created successfully');
        await loadAssemblies(); // Recargar la lista
        state = state.copyWith(isCreating: false);
        return true;
      } else {
        print('❌ Failed to create assembly');
        state = state.copyWith(
          isCreating: false,
          error:
              'Error creando asamblea. Verifique que el nombre no esté repetido.',
        );
        return false;
      }
    } catch (e) {
      print('💥 Error creating assembly: $e');
      state = state.copyWith(
        isCreating: false,
        error: 'Error inesperado al crear asamblea',
      );
      return false;
    }
  }

  Future<bool> updateAssembly(AssemblyEntity assembly) async {
    if (state.isUpdating) {
      print('⚠️ Already updating an assembly');
      return false;
    }

    print('🏛️ Updating assembly: ${assembly.nombre}');
    state = state.copyWith(isUpdating: true, error: null);

    try {
      final success = await _updateAssembly(assembly);

      if (success) {
        print('✅ Assembly updated successfully');
        await loadAssemblies(); // Recargar la lista
        state = state.copyWith(isUpdating: false);
        return true;
      } else {
        print('❌ Failed to update assembly');
        state = state.copyWith(
          isUpdating: false,
          error:
              'Error actualizando asamblea. Verifique que el nombre no esté repetido.',
        );
        return false;
      }
    } catch (e) {
      print('💥 Error updating assembly: $e');
      state = state.copyWith(
        isUpdating: false,
        error: 'Error inesperado al actualizar asamblea',
      );
      return false;
    }
  }

  Future<bool> deleteAssembly(String id) async {
    if (state.isDeleting) {
      print('⚠️ Already deleting an assembly');
      return false;
    }

    print('🏛️ Deleting assembly: $id');
    state = state.copyWith(isDeleting: true, error: null);

    try {
      final success = await _deleteAssembly(id);

      if (success) {
        print('✅ Assembly deleted successfully');
        await loadAssemblies(); // Recargar la lista
        state = state.copyWith(isDeleting: false);
        return true;
      } else {
        print('❌ Failed to delete assembly');
        state = state.copyWith(
          isDeleting: false,
          error: 'Error eliminando asamblea',
        );
        return false;
      }
    } catch (e) {
      print('💥 Error deleting assembly: $e');
      state = state.copyWith(
        isDeleting: false,
        error: 'Error inesperado al eliminar asamblea',
      );
      return false;
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}

final assembliesNotifierProvider =
    StateNotifierProvider<AssembliesNotifier, AssembliesState>((ref) {
  return AssembliesNotifier(
    sl<GetAllAssemblies>(),
    sl<CreateAssembly>(),
    sl<UpdateAssembly>(),
    sl<DeleteAssembly>(),
    sl<GetAssembliesCount>(),
  );
});
