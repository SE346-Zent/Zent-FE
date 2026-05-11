import 'enums/user_roles.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final UserRoles role;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.phoneNumber,
  });
}
