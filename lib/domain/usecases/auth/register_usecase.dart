import 'package:zent_fe/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> signup({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    await repository.signup(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );
  }
}
