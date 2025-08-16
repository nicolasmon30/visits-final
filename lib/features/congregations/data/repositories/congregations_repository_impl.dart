import '../../domain/entities/congregation_entity.dart';
import '../../domain/entities/congregation_details_entity.dart';
import '../../domain/repositories/congregations_repository.dart';
import '../datasources/congregations_local_datasource.dart';
import '../models/congregation_model.dart';
import '../models/congregation_details_model.dart';

class CongregationsRepositoryImpl implements CongregationsRepository {
  final CongregationsLocalDataSource localDataSource;

  CongregationsRepositoryImpl(this.localDataSource);

  @override
  Future<List<CongregationEntity>> getAllCongregations() async {
    return await localDataSource.getAllCongregations();
  }

  @override
  Future<CongregationEntity?> getCongregationById(String id) async {
    return await localDataSource.getCongregationById(id);
  }

  @override
  Future<bool> createCongregation({required String nombre}) async {
    try {
      // Validaciones básicas
      if (nombre.trim().isEmpty) return false;

      // Verificar si ya existe una congregación con el mismo nombre
      final dataSource = localDataSource as CongregationsLocalDataSourceImpl;
      final nameExists = await dataSource.congregationNameExists(nombre.trim());
      if (nameExists) return false;

      final congregation = CongregationModel.create(
        nombre: nombre.trim(),
      );

      return await localDataSource.saveCongregation(congregation);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateCongregation(CongregationEntity congregation) async {
    try {
      if (congregation.nombre.trim().isEmpty) return false;

      // Verificar si ya existe otra congregación con el mismo nombre
      final dataSource = localDataSource as CongregationsLocalDataSourceImpl;
      final nameExists = await dataSource.congregationNameExists(
        congregation.nombre.trim(),
        excludeId: congregation.id,
      );
      if (nameExists) return false;

      final congregationModel = CongregationModel(
        id: congregation.id,
        nombre: congregation.nombre.trim(),
        createdAt: congregation.createdAt,
        updatedAt: DateTime.now(),
      );

      return await localDataSource.updateCongregation(congregationModel);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCongregation(String id) async {
    return await localDataSource.deleteCongregation(id);
  }

  @override
  Future<int> getCongregationsCount() async {
    try {
      final dataSource = localDataSource as CongregationsLocalDataSourceImpl;
      return await dataSource.getCongregationsCount();
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<CongregationDetailsEntity?> getCongregationDetails(
      String congregationId) async {
    return await localDataSource.getCongregationDetails(congregationId);
  }

  @override
  Future<bool> saveCongregationDetails(
      CongregationDetailsEntity details) async {
    try {
      final detailsModel = CongregationDetailsModel.fromEntity(details);
      return await localDataSource.saveCongregationDetails(detailsModel);
    } catch (e) {
      return false;
    }
  }
}
