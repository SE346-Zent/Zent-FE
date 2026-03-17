import 'package:equatable/equatable.dart';

abstract class UserStatusEvent extends Equatable {
  const UserStatusEvent();

  @override
  List<Object?> get props => [];
}

class UserStatusUpdateRequested extends UserStatusEvent {
  final String userName;
  final String status;

  const UserStatusUpdateRequested({
    required this.userName,
    required this.status,
  });

  @override
  List<Object?> get props => [userName, status];
}
