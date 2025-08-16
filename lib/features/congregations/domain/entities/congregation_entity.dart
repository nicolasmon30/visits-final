import 'package:equatable/equatable.dart';

class CongregationEntity extends Equatable {
  final String id;
  final String nombre;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CongregationEntity({
    required this.id,
    required this.nombre,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        createdAt,
        updatedAt,
      ];
}
