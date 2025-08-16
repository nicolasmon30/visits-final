import '../entities/route_entity.dart';
import '../repositories/routes_repository.dart';

class GetAllRoutes {
  final RoutesRepository repository;

  GetAllRoutes(this.repository);

  Future<List<RouteEntity>> call() async {
    return await repository.getAllRoutes();
  }
}

class GetRouteById {
  final RoutesRepository repository;

  GetRouteById(this.repository);

  Future<RouteEntity?> call(String id) async {
    return await repository.getRouteById(id);
  }
}

class CreateRoute {
  final RoutesRepository repository;

  CreateRoute(this.repository);

  Future<bool> call({
    required String actividad,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required bool jw,
    required bool aviso,
    required bool agenda,
    String? detalles,
  }) async {
    return await repository.createRoute(
      actividad: actividad,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      jw: jw,
      aviso: aviso,
      agenda: agenda,
      detalles: detalles,
    );
  }
}

class UpdateRoute {
  final RoutesRepository repository;

  UpdateRoute(this.repository);

  Future<bool> call(RouteEntity route) async {
    return await repository.updateRoute(route);
  }
}

class DeleteRoute {
  final RoutesRepository repository;

  DeleteRoute(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteRoute(id);
  }
}

class GetRoutesCount {
  final RoutesRepository repository;

  GetRoutesCount(this.repository);

  Future<int> call() async {
    return await repository.getRoutesCount();
  }
}
