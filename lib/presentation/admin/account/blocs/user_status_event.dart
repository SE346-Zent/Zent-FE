import 'package:equatable/equatable.dart';
import 'package:zent_fe/domain/entities/enums/user_status.dart';

abstract class UserStatusEvent extends Equatable {
  const UserStatusEvent();

  @override
  List<Object?> get props => [];
}

class UserStatusUpdateRequested extends UserStatusEvent {
  final String userName;
  final UserStatus status;

  const UserStatusUpdateRequested({
    required this.userName,
    required this.status,
  });

  @override
  List<Object?> get props => [userName, status];
}
