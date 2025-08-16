import 'package:equatable/equatable.dart';

class RouteEntity extends Equatable {
  final String id;
  final String actividad;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool jw;
  final bool aviso;
  final bool agenda;
  final String? detalles;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RouteEntity({
    required this.id,
    required this.actividad,
    required this.fechaInicio,
    required this.fechaFin,
    required this.jw,
    required this.aviso,
    required this.agenda,
    this.detalles,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fechaRangeDisplay {
    if (fechaInicio.day == fechaFin.day &&
        fechaInicio.month == fechaFin.month &&
        fechaInicio.year == fechaFin.year) {
      return '${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year}';
    }
    return '${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year} - ${fechaFin.day}/${fechaFin.month}/${fechaFin.year}';
  }

  int get duracionDias {
    return fechaFin.difference(fechaInicio).inDays + 1;
  }

  @override
  List<Object?> get props => [
        id,
        actividad,
        fechaInicio,
        fechaFin,
        jw,
        aviso,
        agenda,
        detalles,
        createdAt,
        updatedAt,
      ];
}
