import '../repositories/auth_repository.dart';

class SetupUserProfile {
  final AuthRepository repository;

  SetupUserProfile(this.repository);

  Future<bool> call({
    required String firstName,
    required String lastName,
    required String nickname,
    required String accessCode,
  }) async {
    if (firstName.isEmpty || lastName.isEmpty || accessCode.isEmpty) {
      return false;
    }

    if (accessCode.length < 4) {
      return false;
    }

    return await repository.setupUserProfile(
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
      accessCode: accessCode,
    );
  }
}
