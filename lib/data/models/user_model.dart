import '../../domain/entities/user.dart' show User;
import '../../domain/entities/enums/user_roles.dart' show UserRoles;

class UserModel extends User {
  UserModel({
    required super.email,
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.role,
    required super.province,
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

    return UserModel(
      id: id,
      email: (json['email'] ?? '').toString(),
      name: (json['fullName'] ?? json['name'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      role: _mapRole(json['role'], json['roleId']),
      province: (json['province'] ?? '').toString(),
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
    };
  }
}
