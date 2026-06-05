import 'enums/user_roles.dart';
import 'enums/account_status.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final UserRoles role;
  final String province;
  final String? avatarUrl;
  final String? employeeId;
  final Map<String, int>? ratingCounts;
  final AccountStatus status;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    this.province = '',
    this.avatarUrl,
    this.employeeId,
    this.ratingCounts,
    this.status = AccountStatus.active,
  });
}
