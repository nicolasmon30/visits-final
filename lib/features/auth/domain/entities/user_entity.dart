import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String accessCode;
  final DateTime lastLogin;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.accessCode,
    required this.lastLogin,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, accessCode, lastLogin, isActive];
}
