import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> signup({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    required UserRoles role,
  }) async {
    await repository.signup(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      role: role,
    );
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await repository.verifyOtp(email: email, otp: otp);
  }

  Future<void> resendOtp(String email) async {
    await repository.resendOtp(email);
  }
}
