import '../../domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.id,
    required super.actividad,
    required super.fechaInicio,
    required super.fechaFin,
    required super.jw,
    required super.aviso,
    required super.agenda,
    super.detalles,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      actividad: json['actividad'] as String,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaFin: DateTime.parse(json['fechaFin'] as String),
      jw: json['jw'] as bool,
      aviso: json['aviso'] as bool,
      agenda: json['agenda'] as bool,
      detalles: json['detalles'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actividad': actividad,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'jw': jw,
      'aviso': aviso,
      'agenda': agenda,
      'detalles': detalles,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  RouteModel copyWith({
    String? id,
    String? actividad,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? jw,
    bool? aviso,
    bool? agenda,
    String? detalles,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RouteModel(
      id: id ?? this.id,
      actividad: actividad ?? this.actividad,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      jw: jw ?? this.jw,
      aviso: aviso ?? this.aviso,
      agenda: agenda ?? this.agenda,
      detalles: detalles ?? this.detalles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RouteModel.create({
    required String actividad,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required bool jw,
    required bool aviso,
    required bool agenda,
    String? detalles,
  }) {
    final now = DateTime.now();
    return RouteModel(
      id: now.millisecondsSinceEpoch.toString(),
      actividad: actividad,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      jw: jw,
      aviso: aviso,
      agenda: agenda,
      detalles: detalles,
      createdAt: now,
      updatedAt: now,
    );
  }
}
