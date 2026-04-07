import 'package:zent_fe/domain/repositories/auth_repository.dart';
import 'package:zent_fe/domain/entities/user.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<User> call({required String email, required String otp}) async {
    return await repository.verifyOtp(email: email, otp: otp);
  }
}
