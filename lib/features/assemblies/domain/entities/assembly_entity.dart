import 'package:equatable/equatable.dart';

class AssemblyEntity extends Equatable {
  final String id;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String lugar;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssemblyEntity({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.lugar,
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
        nombre,
        fechaInicio,
        fechaFin,
        lugar,
        createdAt,
        updatedAt,
      ];
}
