import '../entities/recommendation_entity.dart';

abstract class RecommendationsRepository {
  Future<List<RecommendationEntity>> getRecommendationsByCongregation(
      String congregationId);
  Future<RecommendationEntity?> getRecommendationById(String id);
  Future<bool> createRecommendation({
    required String congregationId,
    required String titulo,
    required TipoRecomendacion tipo,
    required int edad,
    required int anosBautizado,
    required bool censurado,
    DateTime? fechaCensurado,
    required bool sacado,
    DateTime? fechaSacado,
    String? comentarios,
  });
  Future<bool> updateRecommendation(RecommendationEntity recommendation);
  Future<bool> deleteRecommendation(String id);
  Future<int> getRecommendationsCount(String congregationId);
}
