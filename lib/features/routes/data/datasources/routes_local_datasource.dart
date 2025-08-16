import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/route_model.dart';

abstract class RoutesLocalDataSource {
  Future<List<RouteModel>> getAllRoutes();
  Future<RouteModel?> getRouteById(String id);
  Future<bool> saveRoute(RouteModel route);
  Future<bool> deleteRoute(String id);
  Future<bool> updateRoute(RouteModel route);
}

class RoutesLocalDataSourceImpl implements RoutesLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _keyRoutes = 'routes_list';

  RoutesLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<RouteModel>> getAllRoutes() async {
    try {
      final routesJson = sharedPreferences.getString(_keyRoutes);
      if (routesJson == null) return [];

      final List<dynamic> routesList = json.decode(routesJson);
      return routesList
          .map((routeJson) =>
              RouteModel.fromJson(routeJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<RouteModel?> getRouteById(String id) async {
    try {
      final routes = await getAllRoutes();
      return routes.firstWhere(
        (route) => route.id == id,
        orElse: () => throw StateError('Route not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveRoute(RouteModel route) async {
    try {
      final routes = await getAllRoutes();
      routes.add(route);
      return await _saveAllRoutes(routes);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateRoute(RouteModel route) async {
    try {
      final routes = await getAllRoutes();
      final index = routes.indexWhere((r) => r.id == route.id);

      if (index == -1) return false;

      routes[index] = route.copyWith(updatedAt: DateTime.now());
      return await _saveAllRoutes(routes);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRoute(String id) async {
    try {
      final routes = await getAllRoutes();
      routes.removeWhere((route) => route.id == id);
      return await _saveAllRoutes(routes);
    } catch (e) {
      return false;
    }
  }

  Future<bool> _saveAllRoutes(List<RouteModel> routes) async {
    try {
      // Ordenar por fecha de creación (más recientes primero)
      routes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final routesJson = json.encode(
        routes.map((route) => route.toJson()).toList(),
      );

      return await sharedPreferences.setString(_keyRoutes, routesJson);
    } catch (e) {
      return false;
    }
  }

  Future<int> getRoutesCount() async {
    try {
      final routes = await getAllRoutes();
      return routes.length;
    } catch (e) {
      return 0;
    }
  }

  Future<List<RouteModel>> getRoutesByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final routes = await getAllRoutes();
      return routes.where((route) {
        return (route.fechaInicio.isAfter(startDate) ||
                route.fechaInicio.isAtSameMomentAs(startDate)) &&
            (route.fechaFin.isBefore(endDate) ||
                route.fechaFin.isAtSameMomentAs(endDate));
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
