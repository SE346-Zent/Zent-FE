import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/admin/account/blocs/user_status_event.dart';
import 'package:zent_fe/presentation/admin/account/blocs/user_status_state.dart';

class UserStatusBloc extends Bloc<UserStatusEvent, UserStatusState> {
  UserStatusBloc(String initialStatus)
    : super(_mapStringToStatus(initialStatus)) {
    on<UserStatusUpdateRequested>((event, emit) {
      emit(_mapStringToStatus(event.status));
    });
  }

  static UserStatusState _mapStringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return UserStatusActive();
      case 'away':
        return UserStatusAway();
      case 'inactive':
        return UserStatusInactive();
      default:
        return UserStatusInitial(status);
    }
  }
}
