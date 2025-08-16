import '../entities/user_entity.dart';
import '../entities/user_profile_entity.dart';

abstract class AuthRepository {
  Future<bool> authenticate(String code);
  Future<bool> isAuthenticated();
  Future<bool> isFirstTimeUser();
  Future<bool> setupUserProfile({
    required String firstName,
    required String lastName,
    required String nickname,
    required String accessCode,
  });
  Future<UserEntity?> getCurrentUser();
  Future<UserProfileEntity?> getUserProfile();
  Future<void> logout();
  Future<void> resetCompleteUser();
}
