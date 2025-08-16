import '../repositories/auth_repository.dart';

class CheckFirstTime {
  final AuthRepository repository;

  CheckFirstTime(this.repository);

  Future<bool> call() async {
    return await repository.isFirstTimeUser();
  }
}
