import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

abstract class UserStatusState extends Equatable {
  const UserStatusState();

  String get statusText;
  Color get backgroundColor;
  Color get textColor;
  Color get dotColor;

  @override
  List<Object?> get props => [];
}

class UserStatusInitial extends UserStatusState {
  final String status;

  const UserStatusInitial(this.status);

  @override
  String get statusText => status;
  @override
  Color get backgroundColor => AppColors.secondary50;
  @override
  Color get textColor => AppColors.secondary500;
  @override
  Color get dotColor => AppColors.secondary300;

  @override
  List<Object?> get props => [status];
}

class UserStatusActive extends UserStatusState {
  @override
  String get statusText => 'Active';
  @override
  Color get backgroundColor => AppColors.success50;
  @override
  Color get textColor => AppColors.success500;
  @override
  Color get dotColor => AppColors.success500;
}

class UserStatusAway extends UserStatusState {
  @override
  String get statusText => 'Away';
  @override
  Color get backgroundColor => AppColors.warning50;
  @override
  Color get textColor => AppColors.warning500;
  @override
  Color get dotColor => AppColors.warning500;
}

class UserStatusInactive extends UserStatusState {
  @override
  String get statusText => 'Inactive';
  @override
  Color get backgroundColor => AppColors.secondary50;
  @override
  Color get textColor => AppColors.secondary500;
  @override
  Color get dotColor => AppColors.secondary500;
}
