import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/domain/entities/enums/user_status.dart';

abstract class UserStatusState extends Equatable {
  final Map<String, UserStatus> userStatuses;

  const UserStatusState(this.userStatuses);

  @override
  List<Object?> get props => [userStatuses];

  // Helper to get status mapping for a specific user
  UserStatus getStatusFor(String userName) =>
      userStatuses[userName] ?? UserStatus.active;

  static Color getBackgroundColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.success50;
      case UserStatus.away:
        return AppColors.warning50;
      case UserStatus.inactive:
        return AppColors.secondary50;
    }
  }

  static Color getTextColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.success500;
      case UserStatus.away:
        return AppColors.warning500;
      case UserStatus.inactive:
        return AppColors.secondary500;
    }
  }

  static Color getDotColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.success500;
      case UserStatus.away:
        return AppColors.warning500;
      case UserStatus.inactive:
        return AppColors.secondary500;
    }
  }
}

class UserStatusInitial extends UserStatusState {
  const UserStatusInitial(super.userStatuses);
}

class UserStatusUpdateSuccess extends UserStatusState {
  const UserStatusUpdateSuccess(super.userStatuses);
}
