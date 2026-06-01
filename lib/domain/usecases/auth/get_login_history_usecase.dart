import 'package:zent_fe/domain/entities/login_history_entry.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';

class GetLoginHistoryUseCase {
  final AuthRepository repository;

  GetLoginHistoryUseCase(this.repository);

  Future<List<LoginHistoryEntry>> execute() async {
    return await repository.getLoginHistory();
  }
}
