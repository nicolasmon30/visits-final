import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/assembly_model.dart';

abstract class AssembliesLocalDataSource {
  Future<List<AssemblyModel>> getAllAssemblies();
  Future<AssemblyModel?> getAssemblyById(String id);
  Future<bool> saveAssembly(AssemblyModel assembly);
  Future<bool> deleteAssembly(String id);
  Future<bool> updateAssembly(AssemblyModel assembly);
}

class AssembliesLocalDataSourceImpl implements AssembliesLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _keyAssemblies = 'assemblies_list';

  AssembliesLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<AssemblyModel>> getAllAssemblies() async {
    try {
      final assembliesJson = sharedPreferences.getString(_keyAssemblies);
      if (assembliesJson == null) return [];

      final List<dynamic> assembliesList = json.decode(assembliesJson);
      return assembliesList
          .map((assemblyJson) =>
              AssemblyModel.fromJson(assemblyJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all assemblies: $e');
      return [];
    }
  }

  @override
  Future<AssemblyModel?> getAssemblyById(String id) async {
    try {
      final assemblies = await getAllAssemblies();
      return assemblies.firstWhere(
        (assembly) => assembly.id == id,
        orElse: () => throw StateError('Assembly not found'),
      );
    } catch (e) {
      print('Error getting assembly by id: $e');
      return null;
    }
  }

  @override
  Future<bool> saveAssembly(AssemblyModel assembly) async {
    try {
      final assemblies = await getAllAssemblies();
      assemblies.add(assembly);
      return await _saveAllAssemblies(assemblies);
    } catch (e) {
      print('Error saving assembly: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAssembly(AssemblyModel assembly) async {
    try {
      final assemblies = await getAllAssemblies();
      final index = assemblies.indexWhere((a) => a.id == assembly.id);

      if (index == -1) return false;

      assemblies[index] = assembly.copyWith(updatedAt: DateTime.now());
      return await _saveAllAssemblies(assemblies);
    } catch (e) {
      print('Error updating assembly: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteAssembly(String id) async {
    try {
      final assemblies = await getAllAssemblies();
      assemblies.removeWhere((assembly) => assembly.id == id);
      return await _saveAllAssemblies(assemblies);
    } catch (e) {
      print('Error deleting assembly: $e');
      return false;
    }
  }

  Future<bool> _saveAllAssemblies(List<AssemblyModel> assemblies) async {
    try {
      // Ordenar por fecha de inicio (más recientes primero)
      assemblies.sort((a, b) => b.fechaInicio.compareTo(a.fechaInicio));

      final assembliesJson = json.encode(
        assemblies.map((assembly) => assembly.toJson()).toList(),
      );

      return await sharedPreferences.setString(_keyAssemblies, assembliesJson);
    } catch (e) {
      print('Error saving all assemblies: $e');
      return false;
    }
  }

  Future<int> getAssembliesCount() async {
    try {
      final assemblies = await getAllAssemblies();
      return assemblies.length;
    } catch (e) {
      print('Error getting assemblies count: $e');
      return 0;
    }
  }

  Future<List<AssemblyModel>> getAssembliesByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final assemblies = await getAllAssemblies();
      return assemblies.where((assembly) {
        return (assembly.fechaInicio.isAfter(startDate) ||
                assembly.fechaInicio.isAtSameMomentAs(startDate)) &&
            (assembly.fechaFin.isBefore(endDate) ||
                assembly.fechaFin.isAtSameMomentAs(endDate));
      }).toList();
    } catch (e) {
      print('Error getting assemblies by date range: $e');
      return [];
    }
  }

  Future<bool> assemblyNameExists(String nombre, {String? excludeId}) async {
    try {
      final assemblies = await getAllAssemblies();
      return assemblies.any((assembly) =>
          assembly.nombre.toLowerCase() == nombre.toLowerCase() &&
          assembly.id != excludeId);
    } catch (e) {
      print('Error checking if assembly name exists: $e');
      return false;
    }
  }
}
