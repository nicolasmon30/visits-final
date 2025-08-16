import '../../domain/entities/assembly_entity.dart';

class AssemblyModel extends AssemblyEntity {
  const AssemblyModel({
    required super.id,
    required super.nombre,
    required super.fechaInicio,
    required super.fechaFin,
    required super.lugar,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AssemblyModel.fromJson(Map<String, dynamic> json) {
    return AssemblyModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaFin: DateTime.parse(json['fechaFin'] as String),
      lugar: json['lugar'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'lugar': lugar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AssemblyModel copyWith({
    String? id,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? lugar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssemblyModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      lugar: lugar ?? this.lugar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AssemblyModel.create({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
  }) {
    final now = DateTime.now();
    return AssemblyModel(
      id: now.millisecondsSinceEpoch.toString(),
      nombre: nombre,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      lugar: lugar,
      createdAt: now,
      updatedAt: now,
    );
  }
}
