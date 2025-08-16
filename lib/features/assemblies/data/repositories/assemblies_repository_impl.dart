import '../../domain/entities/assembly_entity.dart';
import '../../domain/repositories/assemblies_repository.dart';
import '../datasources/assemblies_local_datasource.dart';
import '../models/assembly_model.dart';

class AssembliesRepositoryImpl implements AssembliesRepository {
  final AssembliesLocalDataSource localDataSource;

  AssembliesRepositoryImpl(this.localDataSource);

  @override
  Future<List<AssemblyEntity>> getAllAssemblies() async {
    return await localDataSource.getAllAssemblies();
  }

  @override
  Future<AssemblyEntity?> getAssemblyById(String id) async {
    return await localDataSource.getAssemblyById(id);
  }

  @override
  Future<bool> createAssembly({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
  }) async {
    try {
      // Validaciones básicas
      if (nombre.trim().isEmpty) return false;
      if (lugar.trim().isEmpty) return false;
      if (fechaFin.isBefore(fechaInicio)) return false;

      // Verificar si ya existe una asamblea con el mismo nombre
      final dataSource = localDataSource as AssembliesLocalDataSourceImpl;
      final nameExists = await dataSource.assemblyNameExists(nombre.trim());
      if (nameExists) return false;

      final assembly = AssemblyModel.create(
        nombre: nombre.trim(),
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        lugar: lugar.trim(),
      );

      return await localDataSource.saveAssembly(assembly);
    } catch (e) {
      print('Error creating assembly in repository: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAssembly(AssemblyEntity assembly) async {
    try {
      if (assembly.nombre.trim().isEmpty) return false;
      if (assembly.lugar.trim().isEmpty) return false;
      if (assembly.fechaFin.isBefore(assembly.fechaInicio)) return false;

      // Verificar si ya existe otra asamblea con el mismo nombre
      final dataSource = localDataSource as AssembliesLocalDataSourceImpl;
      final nameExists = await dataSource.assemblyNameExists(
        assembly.nombre.trim(),
        excludeId: assembly.id,
      );
      if (nameExists) return false;

      final assemblyModel = AssemblyModel(
        id: assembly.id,
        nombre: assembly.nombre.trim(),
        fechaInicio: assembly.fechaInicio,
        fechaFin: assembly.fechaFin,
        lugar: assembly.lugar.trim(),
        createdAt: assembly.createdAt,
        updatedAt: DateTime.now(),
      );

      return await localDataSource.updateAssembly(assemblyModel);
    } catch (e) {
      print('Error updating assembly in repository: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteAssembly(String id) async {
    return await localDataSource.deleteAssembly(id);
  }

  @override
  Future<int> getAssembliesCount() async {
    try {
      final dataSource = localDataSource as AssembliesLocalDataSourceImpl;
      return await dataSource.getAssembliesCount();
    } catch (e) {
      print('Error getting assemblies count in repository: $e');
      return 0;
    }
  }
}
