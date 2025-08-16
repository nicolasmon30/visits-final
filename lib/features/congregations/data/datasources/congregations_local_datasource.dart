import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/congregation_model.dart';
import '../models/congregation_details_model.dart';

abstract class CongregationsLocalDataSource {
  Future<List<CongregationModel>> getAllCongregations();
  Future<CongregationModel?> getCongregationById(String id);
  Future<bool> saveCongregation(CongregationModel congregation);
  Future<bool> deleteCongregation(String id);
  Future<bool> updateCongregation(CongregationModel congregation);

  // Métodos para detalles de congregación
  Future<CongregationDetailsModel?> getCongregationDetails(
      String congregationId);
  Future<bool> saveCongregationDetails(CongregationDetailsModel details);
  Future<bool> deleteCongregationDetails(String congregationId);
}

class CongregationsLocalDataSourceImpl implements CongregationsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _keyCongregations = 'congregations_list';
  static const String _keyCongregationDetails = 'congregation_details_';

  CongregationsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<CongregationModel>> getAllCongregations() async {
    try {
      final congregationsJson = sharedPreferences.getString(_keyCongregations);
      if (congregationsJson == null) return [];

      final List<dynamic> congregationsList = json.decode(congregationsJson);
      return congregationsList
          .map((congregationJson) => CongregationModel.fromJson(
              congregationJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<CongregationModel?> getCongregationById(String id) async {
    try {
      final congregations = await getAllCongregations();
      return congregations.firstWhere(
        (congregation) => congregation.id == id,
        orElse: () => throw StateError('Congregation not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveCongregation(CongregationModel congregation) async {
    try {
      final congregations = await getAllCongregations();
      congregations.add(congregation);
      return await _saveAllCongregations(congregations);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateCongregation(CongregationModel congregation) async {
    try {
      final congregations = await getAllCongregations();
      final index = congregations.indexWhere((c) => c.id == congregation.id);

      if (index == -1) return false;

      congregations[index] = congregation.copyWith(updatedAt: DateTime.now());
      return await _saveAllCongregations(congregations);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCongregation(String id) async {
    try {
      final congregations = await getAllCongregations();
      congregations.removeWhere((congregation) => congregation.id == id);

      // También eliminar los detalles de la congregación
      await deleteCongregationDetails(id);

      return await _saveAllCongregations(congregations);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<CongregationDetailsModel?> getCongregationDetails(
      String congregationId) async {
    try {
      final detailsJson = sharedPreferences
          .getString('$_keyCongregationDetails$congregationId');
      if (detailsJson == null) return null;

      final Map<String, dynamic> detailsMap = json.decode(detailsJson);
      return CongregationDetailsModel.fromJson(detailsMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveCongregationDetails(CongregationDetailsModel details) async {
    try {
      final detailsJson = json.encode(details.toJson());
      return await sharedPreferences.setString(
        '$_keyCongregationDetails${details.congregationId}',
        detailsJson,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCongregationDetails(String congregationId) async {
    try {
      return await sharedPreferences
          .remove('$_keyCongregationDetails$congregationId');
    } catch (e) {
      return false;
    }
  }

  Future<bool> _saveAllCongregations(
      List<CongregationModel> congregations) async {
    try {
      // Ordenar alfabéticamente por nombre
      congregations.sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

      final congregationsJson = json.encode(
        congregations.map((congregation) => congregation.toJson()).toList(),
      );

      return await sharedPreferences.setString(
          _keyCongregations, congregationsJson);
    } catch (e) {
      return false;
    }
  }

  Future<int> getCongregationsCount() async {
    try {
      final congregations = await getAllCongregations();
      return congregations.length;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> congregationNameExists(String nombre,
      {String? excludeId}) async {
    try {
      final congregations = await getAllCongregations();
      return congregations.any((congregation) =>
          congregation.nombre.toLowerCase() == nombre.toLowerCase() &&
          congregation.id != excludeId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasCongregationDetails(String congregationId) async {
    try {
      final details = await getCongregationDetails(congregationId);
      return details != null;
    } catch (e) {
      return false;
    }
  }
}
