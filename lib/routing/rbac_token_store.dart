import 'package:zent_fe/domain/entities/enums/user_roles.dart';

class RbacTokenStore {
  RbacTokenStore._();

  static String? _token;
  static UserRoles _role = UserRoles.unauthenticated;

  static void setToken(String token) => _token = token;
  static void setRole(UserRoles role) => _role = role;
  
  static void clearToken() {
    _token = null;
    _role = UserRoles.unauthenticated;
  }

  static String? get token => _token;
  static UserRoles get role => _role;
}
