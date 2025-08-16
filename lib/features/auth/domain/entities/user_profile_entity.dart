import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String nickname;
  final String accessCode;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isFirstTime;

  const UserProfileEntity({
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.accessCode,
    required this.createdAt,
    required this.lastLogin,
    required this.isFirstTime,
  });

  String get fullName => '$firstName $lastName';
  String get displayName => nickname.isNotEmpty ? nickname : firstName;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        nickname,
        accessCode,
        createdAt,
        lastLogin,
        isFirstTime,
      ];
}
