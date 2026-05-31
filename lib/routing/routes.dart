abstract final class Routes {
  // main routes
  static const splash = '/';
  static const onBoarding = '/onboarding';
  static const login = '/login';

  // auth sub routes

  // forget-password -> verifyOtp -> reset password -> reset-successfully

  // admin top level
  static const adminDashboard = '/admin/dashboard';
  static const adminReports = '/admin/reports';
  static const adminOperationalQueue = '/admin/operational-queue';
  static const adminTeam = '/admin/team';
  static const adminMe = '/admin/me';

  // technician top level
  static const techHome = '/tech/home';
  static const techWorkOrder = '/tech/work-order';
  static const techMessage = '/tech/message';
  static const techMe = '/tech/me';

  // customer top level
  static const customerServices = '/customer/services';
  static const customerMessages = '/customer/messages';
  static const customerMe = '/customer/me';

  // all sub routes

  static const forgetPassword = 'forget-password';
  static const verifyOtp = 'verifyOtp';
  static const resetPassword = 'resetPassword';
  static const resetSuccessfully = 'reset-successfully';
  static const signUp = 'sign-up';

  static const adminNotifications = 'admin-notifications';
  static const adminUserManagement = 'admin-user-management';
  static const adminSecuritySettings = 'admin-security-settings';
  static const adminSystemLog = 'admin-system-log';
  static const adminChooseRoleCreateAccount =
      'admin-choose-role-create-account';
  static const adminCreateAccount = 'admin-create-account';
  static const adminPartRequests = 'admin-part-requests';
  static const adminInventoryAssets = 'admin-inventory-assets';
  static const adminDetailRequest = 'detail-request/:partId';
  static const adminRejectedWorkOrders = 'rejected-work-orders';
  static const adminRejectionDetail = 'rejection-detail/:id';
  static const adminWorkOrderDetails = 'work-order-details/:workOrderId';
  static const adminAssignedWorkOrderDetails =
      'assigned-work-order-details/:workOrderId';
  static const adminViewSchedule = 'view-schedule/:techId';
  static const adminReassignWorkOrder = 'reassign-work-order/:workOrderId';
  static const adminWorkOrderHistory = 'work-order-history';
  static const adminDetailedHistory = 'detailed-history/:workOrderId';

  static const techWorkOrderDetails = 'work-order-details/:workOrderId';
  static const techPauseWorkOrder = 'tech-pause-work-order/:workOrderId';
  static const techRejectWorkOrder = 'tech-reject-work-order/:workOrderId';
  static const completeWorkOrder = 'complete-work-order/:workOrderId';
  static const addNewPart = 'add-new-part';
  static const inventorySearch = 'inventory-search';
  static const techSecuritySettings = 'tech-security-settings';
  static const techWorkOrderHistory = 'work-order-history';
  static const customerSecuritySettings = 'customer-security-settings';
  static const customerNotifications = 'customer-notifications';
  static const notifications = 'notifications';
  static const personalInfo = 'personal-info';
  static const appCamera = '/app-camera';
  static const qrScanner = '/qr-scanner';

  static const myProducts = 'my-products';
  static const customerDetailedProduct = ':serialNumber';
  static const requestService = 'request-service';
  static const activeRepairs = 'active-repairs';
  static const customerCancelWorkOrder = 'cancel-work-order/:workOrderId';
  static const customerWorkOrderHistory = 'work-order-history';

  // // auth route builders
  // static String getAuthForgetPasswordRoute() => '$login/$forgetPassword';
  // static String getAuthVerifyOtpRoute() =>
  //     '${getAuthForgetPasswordRoute()}/$verifyOtp';
  // static String getAuthResetPasswordRoute() =>
  //     '${getAuthVerifyOtpRoute()}/$resetPassword';
  // static String getAuthResetSuccessfullyRoute() =>
  //     '${getAuthResetPasswordRoute()}/$resetSuccessfully';
  // static String getAuthSignUpRoute() => '$login/$signUp';

  // // admin route builders
  // static String getAdminUserManagementRoute() => '$adminMe/$userManagement';
  // static String getAdminSecuritySettingsRoute() => '$adminMe/$securitySettings';
  // static String getAdminSystemLogRoute() => '$adminMe/$systemLog';
  // static String getAdminChooseRoleCreateAccountRoute() =>
  //     '${getAdminUserManagementRoute()}/$chooseRoleCreateAccount';
  // static String getAdminCreateAccountRoute() =>
  //     '${getAdminChooseRoleCreateAccountRoute()}/$createAccount';

  // // technician route builders
  // static String getTechWorkOrderDetailsRoute(String workOrderId) =>
  //     '$techWorkOrder/$techWorkOrderDetails'.replaceAll(
  //       ':workOrderId',
  //       workOrderId,
  //     );
  // static String getTechCompleteWorkOrderRoute(String workOrderId) =>
  //     '${getTechWorkOrderDetailsRoute(workOrderId)}/$completeWorkOrder';
  // static String getTechAddNewPartRoute(String workOrderId) =>
  //     '$techHome/$addNewPart';
  // static String getTechInventorySearchRoute(String workOrderId) =>
  //     '$techHome/$inventorySearch';
  // static String getTechSecurityNotificationsRoute() =>
  //     '$techMe/$securityNotifications';
  // static String getTechPersonalInfoRoute() => '$techMe/$personalInfo';

  // // customer route builders
  // static String getCustomerMyProductsRoute() => '$customerServices/$myProducts';
  // static String getCustomerRequestServiceRoute() =>
  //     '$customerServices/$requestService';
  // static String getCustomerActiveRepairsRoute() =>
  //     '$customerServices/$activeRepairs';
}
