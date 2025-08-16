import '../entities/congregation_entity.dart';
import '../entities/congregation_details_entity.dart';

abstract class CongregationsRepository {
  Future<List<CongregationEntity>> getAllCongregations();
  Future<CongregationEntity?> getCongregationById(String id);
  Future<bool> createCongregation({required String nombre});
  Future<bool> updateCongregation(CongregationEntity congregation);
  Future<bool> deleteCongregation(String id);
  Future<int> getCongregationsCount();

  // Métodos para detalles de congregación
  Future<CongregationDetailsEntity?> getCongregationDetails(
      String congregationId);
  Future<bool> saveCongregationDetails(CongregationDetailsEntity details);
}
