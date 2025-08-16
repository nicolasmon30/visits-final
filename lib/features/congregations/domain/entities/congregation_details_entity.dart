import 'package:equatable/equatable.dart';

class CongregationDetailsEntity extends Equatable {
  final String congregationId;

  // Reunión Entre Semana (6 inputs)
  final List<double?> reunionEntreSemana;

  // Reunión Fin De Semana (6 inputs)
  final List<double?> reunionFinDeSemana;

  // Cursos Bíblicos (6 inputs)
  final List<double?> cursosBiblicos;

  // Publicadores que dirigen cursos bíblicos (6 inputs)
  final List<double?> publicadoresDirigenCursos;

  // Precursores Especiales (6 inputs)
  final List<double?> precursoresEspeciales;

  // Precursores Regulares (6 inputs)
  final List<double?> precursoresRegulares;

  // Precursores Auxiliares (6 inputs)
  final List<double?> precursoresAuxiliares;

  // Total Publicadores (6 inputs)
  final List<double?> totalPublicadores;

  // Publicadores Nuevos (6 inputs)
  final List<double?> publicadoresNuevos;

  // Publicadores Irregulares (6 inputs)
  final List<double?> publicadoresIrregulares;

  // Publicadores Inactivos (6 inputs)
  final List<double?> publicadoresInactivos;

  // Publicadores Reactivados (6 inputs)
  final List<double?> publicadoresReactivados;

  // Readmitidos (6 inputs)
  final List<double?> readmitidos;

  // Ancianos (6 inputs)
  final List<double?> ancianos;

  // Siervos Ministeriales (6 inputs)
  final List<double?> siervosMinisteriales;

  // Text Areas
  final String? aspectosPositivos;
  final String? aspectosAMejorar;

  final DateTime createdAt;
  final DateTime updatedAt;

  const CongregationDetailsEntity({
    required this.congregationId,
    required this.reunionEntreSemana,
    required this.reunionFinDeSemana,
    required this.cursosBiblicos,
    required this.publicadoresDirigenCursos,
    required this.precursoresEspeciales,
    required this.precursoresRegulares,
    required this.precursoresAuxiliares,
    required this.totalPublicadores,
    required this.publicadoresNuevos,
    required this.publicadoresIrregulares,
    required this.publicadoresInactivos,
    required this.publicadoresReactivados,
    required this.readmitidos,
    required this.ancianos,
    required this.siervosMinisteriales,
    this.aspectosPositivos,
    this.aspectosAMejorar,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        congregationId,
        reunionEntreSemana,
        reunionFinDeSemana,
        cursosBiblicos,
        publicadoresDirigenCursos,
        precursoresEspeciales,
        precursoresRegulares,
        precursoresAuxiliares,
        totalPublicadores,
        publicadoresNuevos,
        publicadoresIrregulares,
        publicadoresInactivos,
        publicadoresReactivados,
        readmitidos,
        ancianos,
        siervosMinisteriales,
        aspectosPositivos,
        aspectosAMejorar,
        createdAt,
        updatedAt,
      ];

  // Helper para crear una instancia vacía
  factory CongregationDetailsEntity.empty(String congregationId) {
    final now = DateTime.now();
    return CongregationDetailsEntity(
      congregationId: congregationId,
      reunionEntreSemana: List.filled(6, null),
      reunionFinDeSemana: List.filled(6, null),
      cursosBiblicos: List.filled(6, null),
      publicadoresDirigenCursos: List.filled(6, null),
      precursoresEspeciales: List.filled(6, null),
      precursoresRegulares: List.filled(6, null),
      precursoresAuxiliares: List.filled(6, null),
      totalPublicadores: List.filled(6, null),
      publicadoresNuevos: List.filled(6, null),
      publicadoresIrregulares: List.filled(6, null),
      publicadoresInactivos: List.filled(6, null),
      publicadoresReactivados: List.filled(6, null),
      readmitidos: List.filled(6, null),
      ancianos: List.filled(6, null),
      siervosMinisteriales: List.filled(6, null),
      aspectosPositivos: null,
      aspectosAMejorar: null,
      createdAt: now,
      updatedAt: now,
    );
  }
}
