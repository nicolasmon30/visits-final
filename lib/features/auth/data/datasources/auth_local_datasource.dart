import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/user_profile_model.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveUser(UserModel user);
  Future<bool> saveUserProfile(UserProfileModel profile);
  Future<UserModel?> getUser();
  Future<UserProfileModel?> getUserProfile();
  Future<bool> isUserAuthenticated();
  Future<bool> isFirstTimeUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _keyUserId = 'user_id';
  static const String _keyAccessCode = 'access_code';
  static const String _keyLastLogin = 'last_login';
  static const String _keyIsActive = 'is_active';
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyNickname = 'nickname';
  static const String _keyCreatedAt = 'created_at';
  static const String _keyIsFirstTime = 'is_first_time';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> saveUser(UserModel user) async {
    try {
      await Future.wait([
        sharedPreferences.setString(_keyUserId, user.id),
        sharedPreferences.setString(_keyAccessCode, user.accessCode),
        sharedPreferences.setString(
            _keyLastLogin, user.lastLogin.toIso8601String()),
        sharedPreferences.setBool(_keyIsActive, user.isActive),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveUserProfile(UserProfileModel profile) async {
    try {
      await Future.wait([
        sharedPreferences.setString(_keyFirstName, profile.firstName),
        sharedPreferences.setString(_keyLastName, profile.lastName),
        sharedPreferences.setString(_keyNickname, profile.nickname),
        sharedPreferences.setString(_keyAccessCode, profile.accessCode),
        sharedPreferences.setString(
            _keyCreatedAt, profile.createdAt.toIso8601String()),
        sharedPreferences.setString(
            _keyLastLogin, profile.lastLogin.toIso8601String()),
        sharedPreferences.setBool(_keyIsFirstTime, profile.isFirstTime),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final id = sharedPreferences.getString(_keyUserId);
      final accessCode = sharedPreferences.getString(_keyAccessCode);
      final lastLoginString = sharedPreferences.getString(_keyLastLogin);
      final isActive = sharedPreferences.getBool(_keyIsActive);

      if (id == null ||
          accessCode == null ||
          lastLoginString == null ||
          isActive == null) {
        return null;
      }

      final lastLogin = DateTime.parse(lastLoginString);

      return UserModel(
        id: id,
        accessCode: accessCode,
        lastLogin: lastLogin,
        isActive: isActive,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserProfileModel?> getUserProfile() async {
    try {
      final firstName = sharedPreferences.getString(_keyFirstName);
      final lastName = sharedPreferences.getString(_keyLastName);
      final nickname = sharedPreferences.getString(_keyNickname);
      final accessCode = sharedPreferences.getString(_keyAccessCode);
      final createdAtString = sharedPreferences.getString(_keyCreatedAt);
      final lastLoginString = sharedPreferences.getString(_keyLastLogin);
      final isFirstTime = sharedPreferences.getBool(_keyIsFirstTime);

      if (firstName == null ||
          lastName == null ||
          accessCode == null ||
          createdAtString == null ||
          lastLoginString == null ||
          isFirstTime == null) {
        return null;
      }

      final createdAt = DateTime.parse(createdAtString);
      final lastLogin = DateTime.parse(lastLoginString);

      return UserProfileModel(
        firstName: firstName,
        lastName: lastName,
        nickname: nickname ?? '',
        accessCode: accessCode,
        createdAt: createdAt,
        lastLogin: lastLogin,
        isFirstTime: isFirstTime,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isUserAuthenticated() async {
    try {
      final profile = await getUserProfile();
      if (profile == null) return false;

      // Usuario está autenticado si tiene perfil completo y no es primera vez
      return !profile.isFirstTime;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isFirstTimeUser() async {
    try {
      final profile = await getUserProfile();
      // Es primera vez si no hay perfil guardado
      return profile == null;
    } catch (e) {
      // En caso de error, asumir que es primera vez
      return true;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      // Solo limpiar datos de sesión, NO el perfil del usuario
      await Future.wait([
        sharedPreferences.remove(_keyUserId),
        sharedPreferences.remove(_keyIsActive),
        // NO remover: firstName, lastName, nickname, accessCode, createdAt, isFirstTime
      ]);

      // Marcar como no autenticado pero manteniendo el perfil
      await _markAsLoggedOut();
    } catch (e) {
      // Silently handle error
    }
  }

  /// Limpia COMPLETAMENTE todos los datos (solo para reset/reconfiguración)
  Future<void> clearAllData() async {
    try {
      await Future.wait([
        sharedPreferences.remove(_keyUserId),
        sharedPreferences.remove(_keyAccessCode),
        sharedPreferences.remove(_keyLastLogin),
        sharedPreferences.remove(_keyIsActive),
        sharedPreferences.remove(_keyFirstName),
        sharedPreferences.remove(_keyLastName),
        sharedPreferences.remove(_keyNickname),
        sharedPreferences.remove(_keyCreatedAt),
        sharedPreferences.remove(_keyIsFirstTime),
      ]);
    } catch (e) {
      // Silently handle error
    }
  }

  /// Marca al usuario como deslogueado pero mantiene su perfil
  Future<bool> _markAsLoggedOut() async {
    try {
      final profile = await getUserProfile();
      if (profile == null) return false;

      // Actualizar perfil marcando que necesita autenticarse de nuevo
      final updatedProfile = UserProfileModel(
        firstName: profile.firstName,
        lastName: profile.lastName,
        nickname: profile.nickname,
        accessCode: profile.accessCode,
        createdAt: profile.createdAt,
        lastLogin: profile.lastLogin,
        isFirstTime: false, // Mantener como configurado
      );

      return await saveUserProfile(updatedProfile);
    } catch (e) {
      return false;
    }
  }

  /// Valida si el código ingresado coincide con el código guardado
  Future<bool> validateCode(String inputCode, String savedCode) async {
    try {
      return inputCode.trim() == savedCode.trim();
    } catch (e) {
      return false;
    }
  }

  /// Verifica si existe un perfil de usuario configurado
  Future<bool> hasUserProfile() async {
    try {
      final firstName = sharedPreferences.getString(_keyFirstName);
      final lastName = sharedPreferences.getString(_keyLastName);
      final accessCode = sharedPreferences.getString(_keyAccessCode);

      return firstName != null && lastName != null && accessCode != null;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene solo el nombre de display del usuario (nickname o firstName)
  Future<String?> getDisplayName() async {
    try {
      final profile = await getUserProfile();
      return profile?.displayName;
    } catch (e) {
      return null;
    }
  }

  /// Actualiza solo la fecha de último login
  Future<bool> updateLastLogin() async {
    try {
      final profile = await getUserProfile();
      if (profile == null) return false;

      final updatedProfile = UserProfileModel(
        firstName: profile.firstName,
        lastName: profile.lastName,
        nickname: profile.nickname,
        accessCode: profile.accessCode,
        createdAt: profile.createdAt,
        lastLogin: DateTime.now(),
        isFirstTime: false, // Marcar como no primera vez
      );

      return await saveUserProfile(updatedProfile);
    } catch (e) {
      return false;
    }
  }

  /// Verifica si el usuario ha completado el setup inicial
  Future<bool> isSetupComplete() async {
    try {
      final profile = await getUserProfile();
      return profile != null && !profile.isFirstTime;
    } catch (e) {
      return false;
    }
  }
}
