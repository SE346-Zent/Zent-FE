import 'package:zent_fe/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> execute({
    required String fullName,
    required String phone,
    required String email,
  }) async {
    return await repository.updateProfile(
      fullName: fullName,
      phone: phone,
      email: email,
    );
  }
}
