import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.firstName,
    required super.lastName,
    required super.nickname,
    required super.accessCode,
    required super.createdAt,
    required super.lastLogin,
    required super.isFirstTime,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      nickname: json['nickname'] as String? ?? '',
      accessCode: json['accessCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      isFirstTime: json['isFirstTime'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'accessCode': accessCode,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isFirstTime': isFirstTime,
    };
  }

  UserProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? nickname,
    String? accessCode,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isFirstTime,
  }) {
    return UserProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      accessCode: accessCode ?? this.accessCode,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}
