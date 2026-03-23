import 'package:flutter/foundation.dart';
import 'package:zent_fe/domain/usecases/auth/check_first_time_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/set_first_time_done_usecase.dart';

class SplashViewModel extends ChangeNotifier {
  final CheckFirstTimeUseCase _checkFirstTimeUseCase;
  final SetFirstTimeDoneUseCase _setFirstTimeDoneUseCase;

  SplashViewModel(this._checkFirstTimeUseCase, this._setFirstTimeDoneUseCase);

  Future<bool> resolveFirstTimeFlow() async {
    final isFirstTime = await _checkFirstTimeUseCase();
    if (isFirstTime) {
      await _setFirstTimeDoneUseCase();
    }
    return isFirstTime;
  }
}
