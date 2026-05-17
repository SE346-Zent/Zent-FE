import 'package:zent_fe/domain/repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<void> execute(String email) async {
    await repository.resendOtp(email);
  }
}
