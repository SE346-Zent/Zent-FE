class RbacTokenStore {
  RbacTokenStore._();

  static String? _token;

  static void setToken(String token) => _token = token;
  static void clearToken() => _token = null;
  static String? get token => _token;
}
