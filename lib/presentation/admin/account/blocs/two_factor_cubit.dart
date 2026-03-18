import 'package:flutter_bloc/flutter_bloc.dart';

class TwoFactorCubit extends Cubit<bool> {
  TwoFactorCubit(super.initialState);

  void toggle(bool value) => emit(value);
}
