import '../entities/recommendation_entity.dart';
import '../repositories/recommendations_repository.dart';

class GetRecommendationsByCongregation {
  final RecommendationsRepository repository;

  GetRecommendationsByCongregation(this.repository);

  Future<List<RecommendationEntity>> call(String congregationId) async {
    return await repository.getRecommendationsByCongregation(congregationId);
  }
}

class GetRecommendationById {
  final RecommendationsRepository repository;

  GetRecommendationById(this.repository);

  Future<RecommendationEntity?> call(String id) async {
    return await repository.getRecommendationById(id);
  }
}

class CreateRecommendation {
  final RecommendationsRepository repository;

  CreateRecommendation(this.repository);

  Future<bool> call({
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
    return await repository.createRecommendation(
      congregationId: congregationId,
      titulo: titulo,
      tipo: tipo,
      edad: edad,
      anosBautizado: anosBautizado,
      censurado: censurado,
      fechaCensurado: fechaCensurado,
      sacado: sacado,
      fechaSacado: fechaSacado,
      comentarios: comentarios,
    );
  }
}

class UpdateRecommendation {
  final RecommendationsRepository repository;

  UpdateRecommendation(this.repository);

  Future<bool> call(RecommendationEntity recommendation) async {
    return await repository.updateRecommendation(recommendation);
  }
}

class DeleteRecommendation {
  final RecommendationsRepository repository;

  DeleteRecommendation(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteRecommendation(id);
  }
}

class GetRecommendationsCount {
  final RecommendationsRepository repository;

  GetRecommendationsCount(this.repository);

  Future<int> call(String congregationId) async {
    return await repository.getRecommendationsCount(congregationId);
  }
}
