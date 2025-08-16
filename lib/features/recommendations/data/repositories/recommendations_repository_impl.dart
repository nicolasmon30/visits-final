import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../datasources/recommendations_local_datasource.dart';
import '../models/recommendation_model.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsLocalDataSource localDataSource;

  RecommendationsRepositoryImpl(this.localDataSource);

  @override
  Future<List<RecommendationEntity>> getRecommendationsByCongregation(
      String congregationId) async {
    return await localDataSource
        .getRecommendationsByCongregation(congregationId);
  }

  @override
  Future<RecommendationEntity?> getRecommendationById(String id) async {
    return await localDataSource.getRecommendationById(id);
  }

  @override
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
  }) async {
    try {
      // Validaciones básicas
      if (titulo.trim().isEmpty) return false;
      if (edad <= 0 || edad > 120) return false;
      if (anosBautizado < 0 || anosBautizado > edad) return false;

      // Si está censurado pero no hay fecha, y viceversa
      if (censurado && fechaCensurado == null) {
        // Permitir censurado sin fecha (opcional)
      }

      // Si está sacado pero no hay fecha, y viceversa
      if (sacado && fechaSacado == null) {
        // Permitir sacado sin fecha (opcional)
      }

      final recommendation = RecommendationModel.create(
        congregationId: congregationId,
        titulo: titulo.trim(),
        tipo: tipo,
        edad: edad,
        anosBautizado: anosBautizado,
        censurado: censurado,
        fechaCensurado: fechaCensurado,
        sacado: sacado,
        fechaSacado: fechaSacado,
        comentarios:
            comentarios?.trim().isEmpty == true ? null : comentarios?.trim(),
      );

      return await localDataSource.saveRecommendation(recommendation);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateRecommendation(RecommendationEntity recommendation) async {
    try {
      // Validaciones básicas
      if (recommendation.titulo.trim().isEmpty) return false;
      if (recommendation.edad <= 0 || recommendation.edad > 120) return false;
      if (recommendation.anosBautizado < 0 ||
          recommendation.anosBautizado > recommendation.edad) return false;

      final recommendationModel = RecommendationModel(
        id: recommendation.id,
        congregationId: recommendation.congregationId,
        titulo: recommendation.titulo.trim(),
        tipo: recommendation.tipo,
        edad: recommendation.edad,
        anosBautizado: recommendation.anosBautizado,
        censurado: recommendation.censurado,
        fechaCensurado: recommendation.fechaCensurado,
        sacado: recommendation.sacado,
        fechaSacado: recommendation.fechaSacado,
        comentarios: recommendation.comentarios?.trim().isEmpty == true
            ? null
            : recommendation.comentarios?.trim(),
        createdAt: recommendation.createdAt,
        updatedAt: DateTime.now(),
      );

      return await localDataSource.updateRecommendation(recommendationModel);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRecommendation(String id) async {
    return await localDataSource.deleteRecommendation(id);
  }

  @override
  Future<int> getRecommendationsCount(String congregationId) async {
    try {
      final dataSource = localDataSource as RecommendationsLocalDataSourceImpl;
      return await dataSource
          .getRecommendationsCountByCongregation(congregationId);
    } catch (e) {
      return 0;
    }
  }
}
