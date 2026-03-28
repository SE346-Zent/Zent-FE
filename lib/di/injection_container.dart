import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/datasources/remote/order_remote_datasource.dart';
import '../data/datasources/local/work_order_local_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/work_order_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/work_order_repository.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/logout_usecase.dart';
import '../domain/usecases/auth/first_time_usecase.dart';
import '../domain/usecases/auth/reset_password_usecase.dart';
import '../domain/usecases/auth/verify_otp_usecase.dart';
import '../domain/usecases/work_order/work_order_draft_usecase.dart';
import '../domain/usecases/work_order/get_single_work_order_usecase.dart';
import '../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../presentation/common/intro/viewmodels/splash_viewmodel.dart';
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

// Tech
import 'package:zent_fe/presentation/technician/account/view_models/tech_profile_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/personal_info_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/technician_home_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/view_models/tech_work_order_details_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/view_models/add_new_part_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/view_models/complete_work_order_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/view_models/security_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/view_models/tech_work_order_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Features - Auth ---

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => FirstTimeUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));

  // Work Order Use Cases
  sl.registerLazySingleton(() => WorkOrderDraftUseCase(sl()));
  sl.registerLazySingleton(() => GetSingleWorkOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetManyWorkOrdersUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => SplashViewModel(sl()));
  sl.registerFactory(() => LoginViewModel(sl()));
  sl.registerFactory(() => ForgotPasswordViewModel());
  sl.registerFactory(() => ResetPasswordViewModel(resetPasswordUseCase: sl()));
  sl.registerFactory(() => VerifyOtpViewModel(verifyOtpUseCase: sl()));
  sl.registerFactory(() => UserManagementViewModel());
  sl.registerFactory(() => ProfileViewModel(sl()));
  sl.registerFactory(() => SecuritySettingsViewModel());
  sl.registerFactory(() => CustomerProfileViewModel());
  sl.registerFactory(() => PersonalInfoViewModel());
  sl.registerFactory(() => ServiceViewModel());
  sl.registerFactory(() => ChatViewModel());

  // Tech ViewModels
  sl.registerFactory(() => TechnicianHomeViewModel());
  sl.registerFactory(() => TechWorkOrderViewModel());
  sl.registerFactoryParam<TechWorkOrderDetailsViewModel, String, void>(
    (workOrderId, _) => TechWorkOrderDetailsViewModel(workOrderId: workOrderId),
  );
  sl.registerFactory(() => AddNewPartViewModel());
  sl.registerFactoryParam<CompleteWorkOrderViewModel, String, void>(
    (workOrderId, _) => CompleteWorkOrderViewModel(
      workOrderId: workOrderId,
      workOrderDraftUseCase: sl(),
      getSingleWorkOrderUseCase: sl(),
    ),
  );
  sl.registerFactory(() => TechProfileViewModel());
  sl.registerFactory(() => TechPersonalInfoViewModel());
  sl.registerFactory(() => TechNotificationsViewModel());
  sl.registerFactory(() => TechSecurityViewModel());

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(authRemoteService: sl(), authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<WorkOrderRepository>(
    () =>
        WorkOrderRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<WorkOrderLocalDataSource>(
    () => WorkOrderLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(client: sl(), authLocalDataSource: sl()),
  );

  // --- External ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => http.Client());
}
