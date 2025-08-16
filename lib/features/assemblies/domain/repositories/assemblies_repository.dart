import '../entities/assembly_entity.dart';

abstract class AssembliesRepository {
  Future<List<AssemblyEntity>> getAllAssemblies();
  Future<AssemblyEntity?> getAssemblyById(String id);
  Future<bool> createAssembly({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
  });
  Future<bool> updateAssembly(AssemblyEntity assembly);
  Future<bool> deleteAssembly(String id);
  Future<int> getAssembliesCount();
}
