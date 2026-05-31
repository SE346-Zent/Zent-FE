import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class GetUsersUseCase {
  final AuthRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<User>> execute({
    int page = 1,
    int pageSize = 50,
    String? role,
  }) async {
    return await repository.getUsers(
      page: page,
      pageSize: pageSize,
      role: role,
    );
  }
}
