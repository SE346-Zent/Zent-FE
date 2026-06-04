import '../../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String email, {bool useRecoveryEmail = false}) async {
    return await repository.forgotPassword(
      email,
      useRecoveryEmail: useRecoveryEmail,
    );
  }
}
