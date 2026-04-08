import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> execute() async {
    return await repository.getCurrentUser();
  }
}
