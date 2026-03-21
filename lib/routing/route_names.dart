abstract final class RouteNames {
  // main routes
  static const String splash = 'splash';
  static const String onBoarding = 'onBoarding';
  static const String login = 'login';

  // auth sub routes
  static const String forgotPassword = 'forgotPassword';
  static const String forgotPasswordVerifyOtp = 'forgotPasswordVerifyOtp';
  static const String resetPassword = 'resetPassword';
  static const String resetSuccessfully = 'resetSuccessfully';
  static const String signUp = 'signUp';
  static const String signUpVerifyOtp = 'signUpVerifyOtp';

  // admin top level
  static const String adminDashboard = 'adminDashboard';
  static const String adminReports = 'adminReports';
  static const String adminTeam = 'adminTeam';
  static const String adminMe = 'adminMe';

  // technician top level
  static const String techHome = 'techHome';
  static const String techWorkOrder = 'techWorkOrder';
  static const String techMessage = 'techMessage';
  static const String techMe = 'techMe';

  // customer top level
  static const String customerServices = 'customerServices';
  static const String customerMessages = 'customerMessages';
  static const String customerMe = 'customerMe';

  // all sub routes
  static const String adminUserManagement = 'adminUserManagement';
  static const String adminSecuritySettings = 'adminSecuritySettings';
  static const String adminSystemLog = 'adminSystemLog';
  static const String adminChooseRoleCreateAccount =
      'adminChooseRoleCreateAccount';
  static const String adminCreateAccount = 'adminCreateAccount';

  static const String customerMyProducts = 'customerMyProducts';
  static const String customerRequestService = 'customerRequestService';
  static const String customerActiveRepairs = 'customerActiveRepairs';
  static const String customerPersonalInfo = 'customerPersonalInfo';
}
