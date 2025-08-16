import '../../domain/entities/congregation_entity.dart';

class CongregationModel extends CongregationEntity {
  const CongregationModel({
    required super.id,
    required super.nombre,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CongregationModel.fromJson(Map<String, dynamic> json) {
    return CongregationModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CongregationModel copyWith({
    String? id,
    String? nombre,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CongregationModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CongregationModel.create({
    required String nombre,
  }) {
    final now = DateTime.now();
    return CongregationModel(
      id: now.millisecondsSinceEpoch.toString(),
      nombre: nombre,
      createdAt: now,
      updatedAt: now,
    );
  }
}
