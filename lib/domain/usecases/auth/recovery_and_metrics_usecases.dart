import 'package:zent_fe/domain/repositories/auth_repository.dart';

class SetRecoveryEmailUseCase {
  final AuthRepository repository;

  SetRecoveryEmailUseCase(this.repository);

  Future<void> execute({
    required String recoveryEmail,
    required String password,
  }) async {
    await repository.setRecoveryEmail(
      recoveryEmail: recoveryEmail,
      password: password,
    );
  }
}

class VerifyRecoveryEmailUseCase {
  final AuthRepository repository;

  VerifyRecoveryEmailUseCase(this.repository);

  Future<void> execute({required String otpCode}) async {
    await repository.verifyRecoveryEmail(otpCode: otpCode);
  }
}

class GetTechnicianMetricsUseCase {
  final AuthRepository repository;

  GetTechnicianMetricsUseCase(this.repository);

  Future<Map<String, dynamic>> execute() async {
    return await repository.getTechnicianMetrics();
  }
}
