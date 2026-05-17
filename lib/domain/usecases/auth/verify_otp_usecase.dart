import 'package:zent_fe/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> execute({required String email, required String otp}) async {
    await repository.verifyOtp(email: email, otp: otp);
  }
}
