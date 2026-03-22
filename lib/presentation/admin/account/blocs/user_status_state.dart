import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/domain/entities/enums/account_status.dart';

abstract class UserStatusState extends Equatable {
  final Map<String, AccountStatus> userStatuses;

  const UserStatusState(this.userStatuses);

  @override
  List<Object?> get props => [userStatuses];

  // Helper to get status mapping for a specific user
  AccountStatus getStatusFor(String userName) =>
      userStatuses[userName] ?? AccountStatus.active;

  static Color getBackgroundColor(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return AppColors.success50;
      case AccountStatus.away:
        return AppColors.warning50;
      case AccountStatus.inactive:
        return AppColors.secondary50;
      case AccountStatus.terminated:
        return AppColors.error50;
      case AccountStatus.pending:
        return AppColors.warning50;
    }
  }

  static Color getTextColor(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return AppColors.success500;
      case AccountStatus.away:
        return AppColors.warning500;
      case AccountStatus.inactive:
        return AppColors.secondary500;
      case AccountStatus.terminated:
        return AppColors.error500;
      case AccountStatus.pending:
        return AppColors.warning500;
    }
  }

  static Color getDotColor(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return AppColors.success500;
      case AccountStatus.away:
        return AppColors.warning500;
      case AccountStatus.inactive:
        return AppColors.secondary500;
      case AccountStatus.terminated:
        return AppColors.error500;
      case AccountStatus.pending:
        return AppColors.warning500;
    }
  }
}

class UserStatusInitial extends UserStatusState {
  const UserStatusInitial(super.userStatuses);
}

class UserStatusUpdateSuccess extends UserStatusState {
  const UserStatusUpdateSuccess(super.userStatuses);
}
