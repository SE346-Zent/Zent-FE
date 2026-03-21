import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/logout_usecase.dart';
import '../presentation/common/auth/login/view_models/login_view_model.dart';
import '../presentation/common/auth/login/view_models/forgot_password_view_model.dart';
import '../presentation/common/auth/login/view_models/reset_password_view_model.dart';
import '../presentation/common/auth/login/view_models/verify_otp_view_model.dart';
import '../presentation/admin/account/viewmodel/user_management_viewmodel.dart';
import '../presentation/admin/account/viewmodel/profile_viewmodel.dart';
import '../presentation/admin/account/viewmodel/security_settings_viewmodel.dart';
import '../presentation/customer/account/viewmodels/customer_profile_viewmodel.dart';
import '../presentation/customer/account/viewmodels/personal_info_viewmodel.dart';
import '../presentation/customer/account/viewmodels/service_viewmodel.dart';
import '../presentation/customer/account/viewmodels/chat_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Features - Auth ---

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => LoginViewModel(sl()));
  sl.registerFactory(() => ForgotPasswordViewModel());
  sl.registerFactory(() => ResetPasswordViewModel());
  sl.registerFactory(() => VerifyOtpViewModel());
  sl.registerFactory(() => UserManagementViewModel());
  sl.registerFactory(() => ProfileViewModel(sl()));
  sl.registerFactory(() => SecuritySettingsViewModel());
  sl.registerFactory(() => CustomerProfileViewModel());
  sl.registerFactory(() => PersonalInfoViewModel());
  sl.registerFactory(() => ServiceViewModel());
  sl.registerFactory(() => ChatViewModel());

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(authRemoteService: sl(), authLocalDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), sharedPreferences: sl()),
  );

  // --- External ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => http.Client());
}
