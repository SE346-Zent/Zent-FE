import 'package:zent_fe/domain/repositories/auth_repository.dart';
import 'package:zent_fe/data/models/create_user_request.dart';

class CreateUserUseCase {
  final AuthRepository repository;

  CreateUserUseCase(this.repository);

  Future<void> call(CreateUserRequest request) async {
    return await repository.createUser(request);
  }
}
