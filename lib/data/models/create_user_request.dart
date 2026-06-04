class CreateUserRequest {
  final String email;
  final String fullName;
  final int roleId;
  final String? phone;
  final String? province;
  final bool? generatePassword;
  final String? password;

  CreateUserRequest({
    required this.email,
    required this.fullName,
    required this.roleId,
    this.phone,
    this.province,
    this.generatePassword,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email,
      'fullName': fullName,
      'roleId': roleId,
    };
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone;
    }
    if (province != null && province!.isNotEmpty) {
      map['province'] = province;
    }
    if (generatePassword != null) {
      map['generatePassword'] = generatePassword;
    }
    if (password != null && password!.isNotEmpty) {
      map['password'] = password;
    }
    return map;
  }
}
