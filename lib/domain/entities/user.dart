import 'enums/user_roles.dart';

class User {
  final String id;
  final String email;
  final String name;
  final UserRoles role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}
