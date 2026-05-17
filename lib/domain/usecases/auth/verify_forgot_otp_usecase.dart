import '../../repositories/auth_repository.dart';

class VerifyForgotOtpUseCase {
  final AuthRepository repository;

  VerifyForgotOtpUseCase(this.repository);

  Future<String> call({required String email, required String otp}) async {
    return await repository.verifyForgotOtp(email: email, otp: otp);
  }
}
