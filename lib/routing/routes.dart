abstract final class Routes 
{
  // main routes
  static const splash = '/';
  static const onBoarding = '/onboarding';
  static const login = '/login';

  // sub routes
  static const forgetPassword = 'forget-password';
  static const verifyOtp = 'verifyOtp';
  static const resetPassword = 'resetPassword';
  static const resetSuccessfully = 'reset-successfully';
  // forget-password -> verifyOtp -> reset password -> reset-successfully

  // admin top level 
  static const adminDashboard = '/admin/dashboard';
  static const adminReports = '/admin/reports';
  static const adminTeam = '/admin/team';
  static const me = '/admin/me';

  // technician top level
  static const techHome = '/tech/home';
  static const techWorkOrder = '/tech/work-order';
  static const techMessage = '/tech/message';
  static const techMe = '/tech/me';
}