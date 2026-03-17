import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

abstract class UserStatusState extends Equatable {
  final Map<String, String> userStatuses;

  const UserStatusState(this.userStatuses);

  @override
  List<Object?> get props => [userStatuses];

  // Helper to get status mapping for a specific user
  String getStatusFor(String userName) => userStatuses[userName] ?? 'Active';

  static Color getBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success50;
      case 'away':
        return AppColors.warning50;
      case 'inactive':
        return AppColors.secondary50;
      default:
        return AppColors.secondary50;
    }
  }

  static Color getTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success500;
      case 'away':
        return AppColors.warning500;
      case 'inactive':
        return AppColors.secondary500;
      default:
        return AppColors.secondary500;
    }
  }

  static Color getDotColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success500;
      case 'away':
        return AppColors.warning500;
      case 'inactive':
        return AppColors.secondary500;
      default:
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
