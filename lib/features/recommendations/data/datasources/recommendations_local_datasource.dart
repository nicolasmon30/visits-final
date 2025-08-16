import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recommendation_model.dart';

abstract class RecommendationsLocalDataSource {
  Future<List<RecommendationModel>> getRecommendationsByCongregation(
      String congregationId);
  Future<RecommendationModel?> getRecommendationById(String id);
  Future<bool> saveRecommendation(RecommendationModel recommendation);
  Future<bool> updateRecommendation(RecommendationModel recommendation);
  Future<bool> deleteRecommendation(String id);
}

class RecommendationsLocalDataSourceImpl
    implements RecommendationsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _keyRecommendations = 'recommendations_list';

  RecommendationsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<RecommendationModel>> getRecommendationsByCongregation(
      String congregationId) async {
    try {
      final recommendationsJson =
          sharedPreferences.getString(_keyRecommendations);
      if (recommendationsJson == null) return [];

      final List<dynamic> recommendationsList =
          json.decode(recommendationsJson);
      final allRecommendations = recommendationsList
          .map((recommendationJson) => RecommendationModel.fromJson(
              recommendationJson as Map<String, dynamic>))
          .toList();

      // Filtrar por congregationId y ordenar por fecha de creación (más recientes primero)
      return allRecommendations
          .where((recommendation) =>
              recommendation.congregationId == congregationId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      return [];
    }
  }

  @override
  Future<RecommendationModel?> getRecommendationById(String id) async {
    try {
      final recommendations = await _getAllRecommendations();
      return recommendations.firstWhere(
        (recommendation) => recommendation.id == id,
        orElse: () => throw StateError('Recommendation not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveRecommendation(RecommendationModel recommendation) async {
    try {
      final recommendations = await _getAllRecommendations();
      recommendations.add(recommendation);
      return await _saveAllRecommendations(recommendations);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateRecommendation(RecommendationModel recommendation) async {
    try {
      final recommendations = await _getAllRecommendations();
      final index =
          recommendations.indexWhere((r) => r.id == recommendation.id);

      if (index == -1) return false;

      recommendations[index] =
          recommendation.copyWith(updatedAt: DateTime.now());
      return await _saveAllRecommendations(recommendations);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRecommendation(String id) async {
    try {
      final recommendations = await _getAllRecommendations();
      recommendations.removeWhere((recommendation) => recommendation.id == id);
      return await _saveAllRecommendations(recommendations);
    } catch (e) {
      return false;
    }
  }

  Future<List<RecommendationModel>> _getAllRecommendations() async {
    try {
      final recommendationsJson =
          sharedPreferences.getString(_keyRecommendations);
      if (recommendationsJson == null) return [];

      final List<dynamic> recommendationsList =
          json.decode(recommendationsJson);
      return recommendationsList
          .map((recommendationJson) => RecommendationModel.fromJson(
              recommendationJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> _saveAllRecommendations(
      List<RecommendationModel> recommendations) async {
    try {
      final recommendationsJson = json.encode(
        recommendations
            .map((recommendation) => recommendation.toJson())
            .toList(),
      );

      return await sharedPreferences.setString(
          _keyRecommendations, recommendationsJson);
    } catch (e) {
      return false;
    }
  }

  Future<int> getRecommendationsCountByCongregation(
      String congregationId) async {
    try {
      final recommendations =
          await getRecommendationsByCongregation(congregationId);
      return recommendations.length;
    } catch (e) {
      return 0;
    }
  }
}
