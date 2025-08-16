import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/routes_repository.dart';
import '../datasources/routes_local_datasource.dart';
import '../models/route_model.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final RoutesLocalDataSource localDataSource;

  RoutesRepositoryImpl(this.localDataSource);

  @override
  Future<List<RouteEntity>> getAllRoutes() async {
    return await localDataSource.getAllRoutes();
  }

  @override
  Future<RouteEntity?> getRouteById(String id) async {
    return await localDataSource.getRouteById(id);
  }

  @override
  Future<bool> createRoute({
    required String actividad,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required bool jw,
    required bool aviso,
    required bool agenda,
    String? detalles,
  }) async {
    try {
      // Validaciones básicas
      if (actividad.trim().isEmpty) return false;
      if (fechaFin.isBefore(fechaInicio)) return false;

      final route = RouteModel.create(
        actividad: actividad.trim(),
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        jw: jw,
        aviso: aviso,
        agenda: agenda,
        detalles: detalles?.trim(),
      );

      return await localDataSource.saveRoute(route);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateRoute(RouteEntity route) async {
    try {
      if (route.actividad.trim().isEmpty) return false;
      if (route.fechaFin.isBefore(route.fechaInicio)) return false;

      final routeModel = RouteModel(
        id: route.id,
        actividad: route.actividad.trim(),
        fechaInicio: route.fechaInicio,
        fechaFin: route.fechaFin,
        jw: route.jw,
        aviso: route.aviso,
        agenda: route.agenda,
        detalles: route.detalles?.trim(),
        createdAt: route.createdAt,
        updatedAt: DateTime.now(),
      );

      return await localDataSource.updateRoute(routeModel);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRoute(String id) async {
    return await localDataSource.deleteRoute(id);
  }

  @override
  Future<int> getRoutesCount() async {
    try {
      final dataSource = localDataSource as RoutesLocalDataSourceImpl;
      return await dataSource.getRoutesCount();
    } catch (e) {
      return 0;
    }
  }
}
