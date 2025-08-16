import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';
import '../models/user_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<bool> authenticate(String code) async {
    try {
      final userProfile = await localDataSource.getUserProfile();

      if (userProfile == null) {
        return false;
      }

      final dataSource = localDataSource as AuthLocalDataSourceImpl;
      final isValidCode =
          await dataSource.validateCode(code, userProfile.accessCode);

      if (!isValidCode) {
        return false;
      }

      // Actualizar último login
      final updatedProfile = UserProfileModel(
        firstName: userProfile.firstName,
        lastName: userProfile.lastName,
        nickname: userProfile.nickname,
        accessCode: userProfile.accessCode,
        createdAt: userProfile.createdAt,
        lastLogin: DateTime.now(),
        isFirstTime: false,
      );

      return await localDataSource.saveUserProfile(updatedProfile);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.isUserAuthenticated();
  }

  @override
  Future<bool> isFirstTimeUser() async {
    return await localDataSource.isFirstTimeUser();
  }

  @override
  Future<bool> setupUserProfile({
    required String firstName,
    required String lastName,
    required String nickname,
    required String accessCode,
  }) async {
    try {
      final now = DateTime.now();
      final profile = UserProfileModel(
        firstName: firstName,
        lastName: lastName,
        nickname: nickname,
        accessCode: accessCode,
        createdAt: now,
        lastLogin: now,
        isFirstTime: true,
      );

      return await localDataSource.saveUserProfile(profile);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final profile = await localDataSource.getUserProfile();
      if (profile == null) return null;

      return UserModel(
        id: profile.createdAt.millisecondsSinceEpoch.toString(),
        accessCode: profile.accessCode,
        lastLogin: profile.lastLogin,
        isActive: !profile.isFirstTime,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserProfileEntity?> getUserProfile() async {
    return await localDataSource.getUserProfile();
  }

  @override
  Future<void> logout() async {
    // Solo limpiar sesión, mantener perfil configurado
    await localDataSource.clearUser();
  }

  /// Método para reset completo (usado solo en configuración)
  Future<void> resetCompleteUser() async {
    final dataSource = localDataSource as AuthLocalDataSourceImpl;
    await dataSource.clearAllData();
  }
}
