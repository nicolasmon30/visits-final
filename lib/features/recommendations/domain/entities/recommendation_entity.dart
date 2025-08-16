import 'package:equatable/equatable.dart';

enum TipoRecomendacion { anciano, siervoMinisterial }

class RecommendationEntity extends Equatable {
  final String id;
  final String congregationId;
  final String titulo;
  final TipoRecomendacion tipo;
  final int edad;
  final int anosBautizado;
  final bool censurado;
  final DateTime? fechaCensurado;
  final bool sacado;
  final DateTime? fechaSacado;
  final String? comentarios;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecommendationEntity({
    required this.id,
    required this.congregationId,
    required this.titulo,
    required this.tipo,
    required this.edad,
    required this.anosBautizado,
    required this.censurado,
    this.fechaCensurado,
    required this.sacado,
    this.fechaSacado,
    this.comentarios,
    required this.createdAt,
    required this.updatedAt,
  });

  String get tipoDisplay {
    switch (tipo) {
      case TipoRecomendacion.anciano:
        return 'Anciano';
      case TipoRecomendacion.siervoMinisterial:
        return 'Siervo Ministerial';
    }
  }

  @override
  List<Object?> get props => [
        id,
        congregationId,
        titulo,
        tipo,
        edad,
        anosBautizado,
        censurado,
        fechaCensurado,
        sacado,
        fechaSacado,
        comentarios,
        createdAt,
        updatedAt,
      ];
}
