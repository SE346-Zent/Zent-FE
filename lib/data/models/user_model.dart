import '../../domain/entities/user.dart' show User;
import '../../domain/entities/enums/user_roles.dart' show UserRoles;

class UserModel extends User {
  UserModel({
    required super.email,
    required super.id,
    required super.name,
    required super.role,
  });

  //* from entity -> model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
    );
  }

  //* from json -> model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'temp_id',
      email: json['email'] as String? ?? 'temp_email',
      name: json['fullName'] as String? ?? "abc",
      role: _mapRole(json['role'], json['roleId']),
    );
  }

  static UserRoles _mapRole(dynamic roleStr, dynamic roleId) {
    if (roleId != null) {
      final id = int.tryParse(roleId.toString());
      // Based on API: 1 & 2 are Admins/SuperAdmins, 3 is Technician, 4 is Customer
      if (id == 1 || id == 2) return UserRoles.admin;
      if (id == 3) return UserRoles.customer;
      if (id == 4) return UserRoles.technician;
    }

    if (roleStr != null && roleStr is String) {
      return UserRoles.values.firstWhere(
        (e) => e.name.toUpperCase() == roleStr.toUpperCase(),
        orElse: () => UserRoles.customer, // Default to customer for safety
      );
    }

    return UserRoles.customer; // Default to customer
  }

  //* to json
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'fullName': name, 'role': role.name};
  }
}
