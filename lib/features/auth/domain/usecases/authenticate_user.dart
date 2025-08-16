import '../repositories/auth_repository.dart';

class AuthenticateUser {
  final AuthRepository repository;

  AuthenticateUser(this.repository);

  Future<bool> call(String code) async {
    if (code.isEmpty || code.length < 4) {
      return false;
    }
    return await repository.authenticate(code);
  }
}
