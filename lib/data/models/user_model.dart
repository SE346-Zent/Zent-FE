import '../../domain/entities/user.dart' show User;
import '../../domain/entities/enums/user_roles.dart' show UserRoles;
import '../../domain/entities/enums/account_status.dart' show AccountStatus;
import '../../presentation/common/core/ui/avatar_utils.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.role,
    required super.province,
    super.avatarUrl,
    super.employeeId,
    super.ratingCounts,
    super.status,
  });

  //* from entity -> model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phoneNumber: user.phoneNumber,
      role: user.role,
      province: user.province,
      avatarUrl: user.avatarUrl,
      employeeId: user.employeeId,
      ratingCounts: user.ratingCounts,
      status: user.status,
    );
  }

  //* from json -> model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Robust ID extraction: Check common keys used by different backend versions/libraries
    final String id =
        (json['id'] ??
                json['_id'] ??
                json['userId'] ??
                json['customerId'] ??
                json['sub'] ??
                'temp_id')
            .toString();

    final String? avatarRaw = json['avatarImageName'] as String? ??
        json['avatarName'] as String? ??
        json['avatarUrl'] as String? ??
        json['avatar_url'] as String? ??
        json['avatar'] as String?;

    final ratingCounts = (json['ratingCounts'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, (value as num).toInt()));

    final dynamic statusRaw = json['accountStatus'] ?? json['accountStatusId'] ?? json['statusId'] ?? json['status'];
    AccountStatus status = AccountStatus.active;
    if (statusRaw != null) {
      final str = statusRaw.toString().toLowerCase();
      if (str == '4' || str == 'inactive') {
        status = AccountStatus.inactive;
      } else if (str == '1' || str == 'active') {
        status = AccountStatus.active;
      } else if (str == 'pending') {
        status = AccountStatus.pending;
      } else if (str == 'away') {
        status = AccountStatus.away;
      } else if (str == 'terminated' || str == 'locked') {
        status = AccountStatus.terminated;
      }
    }

    return UserModel(
      id: id,
      email: (json['email'] ?? '').toString(),
      name: (json['fullName'] ?? json['name'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? json['phone'] ?? '').toString(),
      role: _mapRole(json['role'], json['roleId'] ?? json['roleId']),
      province: (json['province'] ?? '').toString(),
      avatarUrl: AvatarUtils.getAvatarUrl(avatarRaw),
      employeeId: (json['employeeId'] ?? json['employee_id'])?.toString(),
      ratingCounts: ratingCounts,
      status: status,
    );
  }

  static UserRoles _mapRole(dynamic roleStr, dynamic roleId) {
    if (roleId != null) {
      final id = int.tryParse(roleId.toString());
      if (id == 1 || id == 2) return UserRoles.admin;
      if (id == 3) return UserRoles.customer;
      if (id == 4) return UserRoles.technician;
    }

    if (roleStr != null && roleStr is String) {
      return UserRoles.values.firstWhere(
        (e) => e.name.toUpperCase() == roleStr.toUpperCase(),
        orElse: () => UserRoles.customer,
      );
    }

    return UserRoles.customer;
  }

  //* to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': name,
      'role': role.name,
      'phoneNumber': phoneNumber,
      'province': province,
      'avatarUrl': avatarUrl,
      'employeeId': employeeId,
      'ratingCounts': ratingCounts,
    };
  }
}
