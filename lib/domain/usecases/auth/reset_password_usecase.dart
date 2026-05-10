import 'package:zent_fe/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<bool> call({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    return await repository.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
    );
  }
}
