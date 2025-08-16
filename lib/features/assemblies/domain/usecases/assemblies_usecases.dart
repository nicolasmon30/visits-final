import '../entities/assembly_entity.dart';
import '../repositories/assemblies_repository.dart';

class GetAllAssemblies {
  final AssembliesRepository repository;

  GetAllAssemblies(this.repository);

  Future<List<AssemblyEntity>> call() async {
    return await repository.getAllAssemblies();
  }
}

class GetAssemblyById {
  final AssembliesRepository repository;

  GetAssemblyById(this.repository);

  Future<AssemblyEntity?> call(String id) async {
    return await repository.getAssemblyById(id);
  }
}

class CreateAssembly {
  final AssembliesRepository repository;

  CreateAssembly(this.repository);

  Future<bool> call({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
  }) async {
    return await repository.createAssembly(
      nombre: nombre,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      lugar: lugar,
    );
  }
}

class UpdateAssembly {
  final AssembliesRepository repository;

  UpdateAssembly(this.repository);

  Future<bool> call(AssemblyEntity assembly) async {
    return await repository.updateAssembly(assembly);
  }
}

class DeleteAssembly {
  final AssembliesRepository repository;

  DeleteAssembly(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteAssembly(id);
  }
}

class GetAssembliesCount {
  final AssembliesRepository repository;

  GetAssembliesCount(this.repository);

  Future<int> call() async {
    return await repository.getAssembliesCount();
  }
}
