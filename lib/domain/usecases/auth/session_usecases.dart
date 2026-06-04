import 'package:zent_fe/domain/entities/user_session.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';

class GetActiveSessionsUseCase {
  final AuthRepository repository;

  GetActiveSessionsUseCase(this.repository);

  Future<List<UserSession>> execute() async {
    return await repository.getActiveSessions();
  }
}

class RevokeSessionUseCase {
  final AuthRepository repository;

  RevokeSessionUseCase(this.repository);

  Future<void> execute(String sessionId) async {
    await repository.revokeSession(sessionId);
  }
}

class RevokeAllOtherSessionsUseCase {
  final AuthRepository repository;

  RevokeAllOtherSessionsUseCase(this.repository);

  Future<void> execute() async {
    await repository.revokeAllOtherSessions();
  }
}
