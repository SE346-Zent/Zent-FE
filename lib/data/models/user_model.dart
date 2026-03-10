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
    String parseRole(String beRole) {
      if (beRole == 'SUPER_ADMIN') return 'SUPERADMIN';
      if (beRole == 'TECHNICIAN') return 'TECHNICIAN';
      if (beRole == 'CUSTOMER') return 'CUSTOMER';
      return 'ADMIN';
    }

    return UserModel(
      id: json['id'] as String? ?? 'temp_id',
      email: json['email'] as String? ?? 'temp_email',
      name: json['fullName'] as String? ?? "abc",
      role: UserRoles.values.firstWhere(
        (e) => e.name.toUpperCase() == parseRole(json['role'] as String? ?? ''),
        orElse: () => UserRoles.admin, // Fallback
      ),
    );
  }

  //* to json
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'fullName': name, 'role': role.name};
  }
}
