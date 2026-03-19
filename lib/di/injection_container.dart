import 'package:get_it/get_it.dart';

// Auth
import 'package:zent_fe/presentation/common/auth/login/view_models/login_view_model.dart';
import 'package:zent_fe/presentation/common/auth/login/view_models/forgot_password_view_model.dart';
import 'package:zent_fe/presentation/common/auth/login/view_models/reset_password_view_model.dart';
import 'package:zent_fe/presentation/common/auth/login/view_models/verify_otp_view_model.dart';
// Tech
import 'package:zent_fe/presentation/technician/account/view_models/tech_profile_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/personal_info_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/security_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/tech_work_order_viewmodel.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // 1, 2, 3, 4. DATA, DOMAIN, CORE, EXTERNAL LAYERS

  // 5. PRESENTATION LAYER (ViewModels)
  // Auth ViewModels
  sl.registerFactory(() => LoginViewModel());
  sl.registerFactory(() => ForgotPasswordViewModel());
  sl.registerFactory(() => ResetPasswordViewModel());
  sl.registerFactory(() => VerifyOtpViewModel());

  // Tech ViewModels
  sl.registerFactory(() => TechProfileViewModel());
  sl.registerFactory(() => TechPersonalInfoViewModel());
  sl.registerFactory(() => TechNotificationsViewModel());
  sl.registerFactory(() => TechSecurityViewModel());
  sl.registerFactory(() => TechWorkOrderViewModel());
}
