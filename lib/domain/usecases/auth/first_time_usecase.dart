import 'package:zent_fe/domain/repositories/auth_repository.dart';

class FirstTimeUseCase {
  final AuthRepository repository;

  FirstTimeUseCase(this.repository);

  Future<bool> check() async {
    return await repository.isFirstTime();
  }

  Future<void> setDone() async {
    await repository.setFirstTimeDone();
  }
}
