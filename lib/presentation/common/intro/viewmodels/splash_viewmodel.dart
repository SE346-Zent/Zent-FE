import 'package:flutter/foundation.dart';
import 'package:zent_fe/domain/usecases/auth/first_time_usecase.dart';

class SplashViewModel extends ChangeNotifier {
  final FirstTimeUseCase _firstTimeUseCase;

  SplashViewModel(this._firstTimeUseCase);

  Future<bool> resolveFirstTimeFlow() async {
    final isFirstTime = await _firstTimeUseCase.check();
    if (isFirstTime) {
      await _firstTimeUseCase.setDone();
    }
    return isFirstTime;
  }
}
