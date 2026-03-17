import 'package:equatable/equatable.dart';

abstract class UserStatusEvent extends Equatable {
  const UserStatusEvent();

  @override
  List<Object?> get props => [];
}

class UserStatusUpdateRequested extends UserStatusEvent {
  final String status;

  const UserStatusUpdateRequested(this.status);

  @override
  List<Object?> get props => [status];
}
