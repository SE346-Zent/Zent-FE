import 'package:flutter/material.dart';

class CompanyInfo {
  final String companyName;
  final String address;

  CompanyInfo({required this.companyName, required this.address});
}

class CompanyInputData {
  final String companyName;
  final String taxId;
  final String primaryAddress;
  final String contactPerson;

  CompanyInputData({
    required this.companyName,
    required this.taxId,
    required this.primaryAddress,
    required this.contactPerson,
  });
}

class CompanySettingsViewModel extends ChangeNotifier {
  String avatarUrl = 'https://picsum.photos/200';

  CompanyInfo companyInfo = CompanyInfo(
    companyName: 'Google',
    address: '1600 Amphitheatre Parkway, Mountain View, CA 94043',
  );

  CompanyInputData inputData = CompanyInputData(
    companyName: 'Google',
    taxId: 'ABC-123456',
    primaryAddress: '7, Bui Thi Xuan, Phuong Sai Gon, TPHCM',
    contactPerson: 'Hung dep zai',
  );

  void updateCompanyInfo() {
    debugPrint("action triggered: Viewmodel logic updateCompanyInfo");
  }

  void editAvatar() {
    debugPrint("action triggered: Viewmodel logic editAvatar");
  }
}
