import 'package:flutter/foundation.dart';
import 'package:zent_fe/domain/usecases/auth/first_time_usecase.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';

class SplashViewModel extends ChangeNotifier {
  final FirstTimeUseCase _firstTimeUseCase;
  final AuthRepository _authRepository;

  SplashViewModel(this._firstTimeUseCase, this._authRepository);

  Future<bool> resolveFirstTimeFlow() async {
    final isFirstTime = await _firstTimeUseCase.check();
    if (isFirstTime) {
      await _firstTimeUseCase.setDone();
    } else {
      // Khôi phục Token và Role từ bộ nhớ máy
      await _authRepository.restoreSession();
    }
    return isFirstTime;
  }
}
