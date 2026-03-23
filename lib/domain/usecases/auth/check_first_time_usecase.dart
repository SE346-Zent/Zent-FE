import 'package:zent_fe/domain/repositories/auth_repository.dart';

class CheckFirstTimeUseCase {
  final AuthRepository repository;

  CheckFirstTimeUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isFirstTime();
  }
}
