import '../entities/congregation_entity.dart';
import '../entities/congregation_details_entity.dart';
import '../repositories/congregations_repository.dart';

class GetAllCongregations {
  final CongregationsRepository repository;

  GetAllCongregations(this.repository);

  Future<List<CongregationEntity>> call() async {
    return await repository.getAllCongregations();
  }
}

class GetCongregationById {
  final CongregationsRepository repository;

  GetCongregationById(this.repository);

  Future<CongregationEntity?> call(String id) async {
    return await repository.getCongregationById(id);
  }
}

class CreateCongregation {
  final CongregationsRepository repository;

  CreateCongregation(this.repository);

  Future<bool> call({required String nombre}) async {
    return await repository.createCongregation(nombre: nombre);
  }
}

class UpdateCongregation {
  final CongregationsRepository repository;

  UpdateCongregation(this.repository);

  Future<bool> call(CongregationEntity congregation) async {
    return await repository.updateCongregation(congregation);
  }
}

class DeleteCongregation {
  final CongregationsRepository repository;

  DeleteCongregation(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteCongregation(id);
  }
}

class GetCongregationsCount {
  final CongregationsRepository repository;

  GetCongregationsCount(this.repository);

  Future<int> call() async {
    return await repository.getCongregationsCount();
  }
}

// Use cases para detalles de congregación
class GetCongregationDetails {
  final CongregationsRepository repository;

  GetCongregationDetails(this.repository);

  Future<CongregationDetailsEntity?> call(String congregationId) async {
    return await repository.getCongregationDetails(congregationId);
  }
}

class SaveCongregationDetails {
  final CongregationsRepository repository;

  SaveCongregationDetails(this.repository);

  Future<bool> call(CongregationDetailsEntity details) async {
    return await repository.saveCongregationDetails(details);
  }
}
