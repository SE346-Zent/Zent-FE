import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/admin/account/blocs/user_status_event.dart';
import 'package:zent_fe/presentation/admin/account/blocs/user_status_state.dart';

class UserStatusBloc extends Bloc<UserStatusEvent, UserStatusState> {
  UserStatusBloc(Map<String, String> initialStatuses)
    : super(UserStatusInitial(initialStatuses)) {
    on<UserStatusUpdateRequested>((event, emit) {
      final newStatuses = Map<String, String>.from(state.userStatuses);
      newStatuses[event.userName] = event.status;
      emit(UserStatusUpdateSuccess(newStatuses));
    });
  }
}
