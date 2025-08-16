import '../../domain/entities/congregation_details_entity.dart';

class CongregationDetailsModel extends CongregationDetailsEntity {
  const CongregationDetailsModel({
    required super.congregationId,
    required super.reunionEntreSemana,
    required super.reunionFinDeSemana,
    required super.cursosBiblicos,
    required super.publicadoresDirigenCursos,
    required super.precursoresEspeciales,
    required super.precursoresRegulares,
    required super.precursoresAuxiliares,
    required super.totalPublicadores,
    required super.publicadoresNuevos,
    required super.publicadoresIrregulares,
    required super.publicadoresInactivos,
    required super.publicadoresReactivados,
    required super.readmitidos,
    required super.ancianos,
    required super.siervosMinisteriales,
    super.aspectosPositivos,
    super.aspectosAMejorar,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CongregationDetailsModel.fromJson(Map<String, dynamic> json) {
    return CongregationDetailsModel(
      congregationId: json['congregationId'] as String,
      reunionEntreSemana: _parseDoubleList(json['reunionEntreSemana']),
      reunionFinDeSemana: _parseDoubleList(json['reunionFinDeSemana']),
      cursosBiblicos: _parseDoubleList(json['cursosBiblicos']),
      publicadoresDirigenCursos:
          _parseDoubleList(json['publicadoresDirigenCursos']),
      precursoresEspeciales: _parseDoubleList(json['precursoresEspeciales']),
      precursoresRegulares: _parseDoubleList(json['precursoresRegulares']),
      precursoresAuxiliares: _parseDoubleList(json['precursoresAuxiliares']),
      totalPublicadores: _parseDoubleList(json['totalPublicadores']),
      publicadoresNuevos: _parseDoubleList(json['publicadoresNuevos']),
      publicadoresIrregulares:
          _parseDoubleList(json['publicadoresIrregulares']),
      publicadoresInactivos: _parseDoubleList(json['publicadoresInactivos']),
      publicadoresReactivados:
          _parseDoubleList(json['publicadoresReactivados']),
      readmitidos: _parseDoubleList(json['readmitidos']),
      ancianos: _parseDoubleList(json['ancianos']),
      siervosMinisteriales: _parseDoubleList(json['siervosMinisteriales']),
      aspectosPositivos: json['aspectosPositivos'] as String?,
      aspectosAMejorar: json['aspectosAMejorar'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'congregationId': congregationId,
      'reunionEntreSemana': _serializeDoubleList(reunionEntreSemana),
      'reunionFinDeSemana': _serializeDoubleList(reunionFinDeSemana),
      'cursosBiblicos': _serializeDoubleList(cursosBiblicos),
      'publicadoresDirigenCursos':
          _serializeDoubleList(publicadoresDirigenCursos),
      'precursoresEspeciales': _serializeDoubleList(precursoresEspeciales),
      'precursoresRegulares': _serializeDoubleList(precursoresRegulares),
      'precursoresAuxiliares': _serializeDoubleList(precursoresAuxiliares),
      'totalPublicadores': _serializeDoubleList(totalPublicadores),
      'publicadoresNuevos': _serializeDoubleList(publicadoresNuevos),
      'publicadoresIrregulares': _serializeDoubleList(publicadoresIrregulares),
      'publicadoresInactivos': _serializeDoubleList(publicadoresInactivos),
      'publicadoresReactivados': _serializeDoubleList(publicadoresReactivados),
      'readmitidos': _serializeDoubleList(readmitidos),
      'ancianos': _serializeDoubleList(ancianos),
      'siervosMinisteriales': _serializeDoubleList(siervosMinisteriales),
      'aspectosPositivos': aspectosPositivos,
      'aspectosAMejorar': aspectosAMejorar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static List<double?> _parseDoubleList(dynamic json) {
    if (json == null) return List.filled(6, null);
    final List<dynamic> list = json as List<dynamic>;
    return list.map((e) => e == null ? null : (e as num).toDouble()).toList();
  }

  static List<double?> _serializeDoubleList(List<double?> list) {
    return list;
  }

  CongregationDetailsModel copyWith({
    String? congregationId,
    List<double?>? reunionEntreSemana,
    List<double?>? reunionFinDeSemana,
    List<double?>? cursosBiblicos,
    List<double?>? publicadoresDirigenCursos,
    List<double?>? precursoresEspeciales,
    List<double?>? precursoresRegulares,
    List<double?>? precursoresAuxiliares,
    List<double?>? totalPublicadores,
    List<double?>? publicadoresNuevos,
    List<double?>? publicadoresIrregulares,
    List<double?>? publicadoresInactivos,
    List<double?>? publicadoresReactivados,
    List<double?>? readmitidos,
    List<double?>? ancianos,
    List<double?>? siervosMinisteriales,
    String? aspectosPositivos,
    String? aspectosAMejorar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CongregationDetailsModel(
      congregationId: congregationId ?? this.congregationId,
      reunionEntreSemana: reunionEntreSemana ?? this.reunionEntreSemana,
      reunionFinDeSemana: reunionFinDeSemana ?? this.reunionFinDeSemana,
      cursosBiblicos: cursosBiblicos ?? this.cursosBiblicos,
      publicadoresDirigenCursos:
          publicadoresDirigenCursos ?? this.publicadoresDirigenCursos,
      precursoresEspeciales:
          precursoresEspeciales ?? this.precursoresEspeciales,
      precursoresRegulares: precursoresRegulares ?? this.precursoresRegulares,
      precursoresAuxiliares:
          precursoresAuxiliares ?? this.precursoresAuxiliares,
      totalPublicadores: totalPublicadores ?? this.totalPublicadores,
      publicadoresNuevos: publicadoresNuevos ?? this.publicadoresNuevos,
      publicadoresIrregulares:
          publicadoresIrregulares ?? this.publicadoresIrregulares,
      publicadoresInactivos:
          publicadoresInactivos ?? this.publicadoresInactivos,
      publicadoresReactivados:
          publicadoresReactivados ?? this.publicadoresReactivados,
      readmitidos: readmitidos ?? this.readmitidos,
      ancianos: ancianos ?? this.ancianos,
      siervosMinisteriales: siervosMinisteriales ?? this.siervosMinisteriales,
      aspectosPositivos: aspectosPositivos ?? this.aspectosPositivos,
      aspectosAMejorar: aspectosAMejorar ?? this.aspectosAMejorar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory CongregationDetailsModel.fromEntity(
      CongregationDetailsEntity entity) {
    return CongregationDetailsModel(
      congregationId: entity.congregationId,
      reunionEntreSemana: entity.reunionEntreSemana,
      reunionFinDeSemana: entity.reunionFinDeSemana,
      cursosBiblicos: entity.cursosBiblicos,
      publicadoresDirigenCursos: entity.publicadoresDirigenCursos,
      precursoresEspeciales: entity.precursoresEspeciales,
      precursoresRegulares: entity.precursoresRegulares,
      precursoresAuxiliares: entity.precursoresAuxiliares,
      totalPublicadores: entity.totalPublicadores,
      publicadoresNuevos: entity.publicadoresNuevos,
      publicadoresIrregulares: entity.publicadoresIrregulares,
      publicadoresInactivos: entity.publicadoresInactivos,
      publicadoresReactivados: entity.publicadoresReactivados,
      readmitidos: entity.readmitidos,
      ancianos: entity.ancianos,
      siervosMinisteriales: entity.siervosMinisteriales,
      aspectosPositivos: entity.aspectosPositivos,
      aspectosAMejorar: entity.aspectosAMejorar,
      createdAt: entity.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
