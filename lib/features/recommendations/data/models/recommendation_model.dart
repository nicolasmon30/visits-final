import '../../domain/entities/recommendation_entity.dart';

class RecommendationModel extends RecommendationEntity {
  const RecommendationModel({
    required super.id,
    required super.congregationId,
    required super.titulo,
    required super.tipo,
    required super.edad,
    required super.anosBautizado,
    required super.censurado,
    super.fechaCensurado,
    required super.sacado,
    super.fechaSacado,
    super.comentarios,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] as String,
      congregationId: json['congregationId'] as String,
      titulo: json['titulo'] as String,
      tipo: TipoRecomendacion.values[json['tipo'] as int],
      edad: json['edad'] as int,
      anosBautizado: json['anosBautizado'] as int,
      censurado: json['censurado'] as bool,
      fechaCensurado: json['fechaCensurado'] != null
          ? DateTime.parse(json['fechaCensurado'] as String)
          : null,
      sacado: json['sacado'] as bool,
      fechaSacado: json['fechaSacado'] != null
          ? DateTime.parse(json['fechaSacado'] as String)
          : null,
      comentarios: json['comentarios'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'congregationId': congregationId,
      'titulo': titulo,
      'tipo': tipo.index,
      'edad': edad,
      'anosBautizado': anosBautizado,
      'censurado': censurado,
      'fechaCensurado': fechaCensurado?.toIso8601String(),
      'sacado': sacado,
      'fechaSacado': fechaSacado?.toIso8601String(),
      'comentarios': comentarios,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  RecommendationModel copyWith({
    String? id,
    String? congregationId,
    String? titulo,
    TipoRecomendacion? tipo,
    int? edad,
    int? anosBautizado,
    bool? censurado,
    DateTime? fechaCensurado,
    bool? sacado,
    DateTime? fechaSacado,
    String? comentarios,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecommendationModel(
      id: id ?? this.id,
      congregationId: congregationId ?? this.congregationId,
      titulo: titulo ?? this.titulo,
      tipo: tipo ?? this.tipo,
      edad: edad ?? this.edad,
      anosBautizado: anosBautizado ?? this.anosBautizado,
      censurado: censurado ?? this.censurado,
      fechaCensurado: fechaCensurado ?? this.fechaCensurado,
      sacado: sacado ?? this.sacado,
      fechaSacado: fechaSacado ?? this.fechaSacado,
      comentarios: comentarios ?? this.comentarios,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RecommendationModel.create({
    required String congregationId,
    required String titulo,
    required TipoRecomendacion tipo,
    required int edad,
    required int anosBautizado,
    required bool censurado,
    DateTime? fechaCensurado,
    required bool sacado,
    DateTime? fechaSacado,
    String? comentarios,
  }) {
    final now = DateTime.now();
    return RecommendationModel(
      id: now.millisecondsSinceEpoch.toString(),
      congregationId: congregationId,
      titulo: titulo,
      tipo: tipo,
      edad: edad,
      anosBautizado: anosBautizado,
      censurado: censurado,
      fechaCensurado: fechaCensurado,
      sacado: sacado,
      fechaSacado: fechaSacado,
      comentarios: comentarios,
      createdAt: now,
      updatedAt: now,
    );
  }
}
