import '../repositories/auth_repository.dart';

class ResetUser {
  final AuthRepository repository;

  ResetUser(this.repository);

  Future<void> call() async {
    await repository.resetCompleteUser();
  }
}
