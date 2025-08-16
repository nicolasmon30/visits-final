import '../entities/route_entity.dart';

abstract class RoutesRepository {
  Future<List<RouteEntity>> getAllRoutes();
  Future<RouteEntity?> getRouteById(String id);
  Future<bool> createRoute({
    required String actividad,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required bool jw,
    required bool aviso,
    required bool agenda,
    String? detalles,
  });
  Future<bool> updateRoute(RouteEntity route);
  Future<bool> deleteRoute(String id);
  Future<int> getRoutesCount();
}
