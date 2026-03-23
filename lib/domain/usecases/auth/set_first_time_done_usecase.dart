import 'package:zent_fe/domain/repositories/auth_repository.dart';

class SetFirstTimeDoneUseCase {
  final AuthRepository repository;

  SetFirstTimeDoneUseCase(this.repository);

  Future<void> call() async {
    await repository.setFirstTimeDone();
  }
}
