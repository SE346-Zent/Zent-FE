import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/datasources/remote/work_order_remote_datasource.dart';
import '../data/datasources/local/work_order_local_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/work_order_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/work_order_repository.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/google_login_usecase.dart';
import '../domain/usecases/auth/logout_usecase.dart';
import '../domain/usecases/auth/first_time_usecase.dart';
import '../domain/usecases/auth/reset_password_usecase.dart';
import '../domain/usecases/auth/get_current_user_usecase.dart';
import '../domain/usecases/auth/register_usecase.dart';
import '../domain/usecases/auth/verify_otp_usecase.dart';
import '../domain/usecases/auth/resend_otp_usecase.dart';
import '../domain/usecases/auth/forgot_password_usecase.dart';
import '../domain/usecases/auth/verify_forgot_otp_usecase.dart';
import '../domain/usecases/work_order/reassign_work_order_usecase.dart';
import '../domain/usecases/work_order/work_order_draft_usecase.dart';
import '../domain/usecases/work_order/get_single_work_order_usecase.dart';
import '../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../domain/usecases/work_order/create_work_order_usecase.dart';
import '../domain/usecases/work_order/get_active_repairs_usecase.dart';
import '../domain/usecases/work_order/refuse_work_order_usecase.dart';
import '../domain/usecases/work_order/approve_refusal_usecase.dart';
import '../domain/usecases/work_order/deny_refusal_usecase.dart';
import '../domain/usecases/work_order/change_appointment_usecase.dart';
import '../domain/usecases/work_order/cancel_work_order_usecase.dart';
import '../domain/usecases/work_order/assign_work_order_usecase.dart';
import '../domain/usecases/work_order/get_technicians_usecase.dart';
import '../domain/usecases/product/get_my_products_usecase.dart';
import '../domain/repositories/product_repository.dart';
import '../data/repositories/product_repository_impl.dart';
import '../data/datasources/remote/product_remote_datasource.dart';
import '../domain/repositories/notification_repository.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../data/datasources/remote/notification_remote_datasource.dart';
import '../domain/usecases/notification/get_notifications_usecase.dart';
import '../domain/usecases/notification/get_unread_count_usecase.dart';
import '../presentation/common/notifications/viewmodels/notifications_viewmodel.dart';
import '../presentation/common/intro/viewmodels/splash_viewmodel.dart';
import '../presentation/common/auth/login/view_models/login_view_model.dart';
import '../presentation/common/auth/login/view_models/forgot_password_view_model.dart';
import '../presentation/common/auth/login/view_models/reset_password_view_model.dart';
import '../presentation/common/auth/login/view_models/verify_forgot_otp_view_model.dart';
import '../presentation/common/auth/register/view_models/verify_otp_view_model.dart';
import '../presentation/admin/account/viewmodels/user_management_viewmodel.dart';
import '../presentation/admin/account/viewmodels/profile_viewmodel.dart';
import '../presentation/admin/account/viewmodels/security_settings_viewmodel.dart';
import '../presentation/admin/account/viewmodels/part_request_viewmodel.dart';
import '../presentation/admin/account/viewmodels/inventory_assets_viewmodel.dart';
import '../presentation/admin/account/viewmodels/detail_request_viewmodel.dart';
import '../presentation/admin/account/viewmodels/choose_role_viewmodel.dart';
import '../presentation/admin/account/viewmodels/create_account_viewmodel.dart';
import '../presentation/admin/work/viewmodels/admin_dashboard_viewmodel.dart';
import '../presentation/admin/work/viewmodels/admin_notifications_viewmodel.dart';
import '../presentation/admin/work/viewmodels/admin_reports_viewmodel.dart';
import '../presentation/admin/work/viewmodels/operational_queue_viewmodel.dart';
import '../presentation/admin/work/viewmodels/assign_work_order_viewmodel.dart';
import '../presentation/admin/work/viewmodels/assigned_work_order_detail_viewmodel.dart';
import '../presentation/admin/work/viewmodels/view_schedule_viewmodel.dart';
import '../presentation/admin/work/viewmodels/change_appointment_viewmodel.dart';
import '../presentation/admin/work/viewmodels/reassign_work_order_viewmodel.dart';
import '../presentation/admin/work/viewmodels/rejected_work_orders_viewmodel.dart';
import '../presentation/admin/work/viewmodels/rejection_detail_viewmodel.dart';
import '../presentation/admin/work/viewmodels/work_orders_history_viewmodel.dart';
import '../presentation/admin/work/viewmodels/detailed_history_viewmodel.dart';
import '../presentation/customer/account/viewmodels/customer_profile_viewmodel.dart';
import '../presentation/customer/account/viewmodels/personal_info_viewmodel.dart';
import '../presentation/customer/work/viewmodels/service_viewmodel.dart';
import '../presentation/customer/account/viewmodels/chat_viewmodel.dart';
import '../presentation/customer/account/viewmodels/security_viewmodel.dart';
import '../presentation/customer/account/viewmodels/notifications_viewmodel.dart';
import '../presentation/customer/account/viewmodels/detailed_chat_viewmodel.dart';
import 'package:zent_fe/data/services/chat_service.dart';
import 'package:zent_fe/data/services/intercepted_http_client.dart';
import '../presentation/customer/work/viewmodels/products_viewmodel.dart';
import '../presentation/customer/work/viewmodels/detailed_product_viewmodel.dart';
import '../presentation/customer/work/viewmodels/request_service_viewmodel.dart';
import '../presentation/customer/work/viewmodels/active_repairs_viewmodel.dart';
import '../presentation/customer/work/viewmodels/customer_cancel_work_order_viewmodel.dart';
import '../presentation/customer/work/viewmodels/device_registration_viewmodel.dart';
import '../presentation/customer/work/viewmodels/parts_viewmodel.dart';
import '../presentation/common/auth/register/view_models/register_view_model.dart';
import '../presentation/common/auth/auth_view_model.dart';

// Tech
import 'package:zent_fe/presentation/technician/account/viewmodels/tech_profile_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/viewmodels/personal_info_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/viewmodels/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/technician/home/viewmodels/technician_home_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/tech_work_order_details_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/tech_pause_work_order_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/tech_reject_work_order_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/add_new_part_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/complete_work_order_viewmodel.dart';
import 'package:zent_fe/presentation/technician/account/viewmodels/security_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/tech_work_order_viewmodel.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/part_search_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Features - Auth ---

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => FirstTimeUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyForgotOtpUseCase(sl()));

  // Work Order Use Cases
  sl.registerLazySingleton(() => WorkOrderDraftUseCase(sl()));
  sl.registerLazySingleton(() => GetSingleWorkOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetManyWorkOrdersUseCase(sl()));
  sl.registerLazySingleton(() => CreateWorkOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveRepairsUseCase(sl()));
  sl.registerLazySingleton(() => GetMyProductsUseCase(sl()));
  sl.registerLazySingleton(() => RefuseWorkOrderUseCase(sl()));
  sl.registerLazySingleton(() => ApproveRefusalUseCase(sl()));
  sl.registerLazySingleton(() => DenyRefusalUseCase(sl()));
  sl.registerLazySingleton(() => ChangeAppointmentUseCase(repository: sl()));
  sl.registerLazySingleton(() => ReassignWorkOrderUseCase(repository: sl()));
  sl.registerLazySingleton(() => CancelWorkOrderUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTechniciansUseCase(repository: sl()));
  sl.registerLazySingleton(() => AssignWorkOrderUseCase(repository: sl()));

  // Notification Use Cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetUnreadCountUseCase(sl()));

  // ViewModels
  sl.registerLazySingleton(() => AuthViewModel());
  sl.registerFactory(() => SplashViewModel(sl(), sl()));
  sl.registerFactory(() => LoginViewModel(sl(), sl()));
  sl.registerFactory(() => RegisterViewModel(registerUseCase: sl()));
  sl.registerFactory(
    () => ForgotPasswordViewModel(forgotPasswordUseCase: sl()),
  );
  sl.registerFactory(
    () => VerifyForgotOtpViewModel(
      verifyForgotOtpUseCase: sl(),
      forgotPasswordUseCase: sl(),
    ),
  );
  sl.registerFactory(() => ResetPasswordViewModel(resetPasswordUseCase: sl()));
  sl.registerFactory(
    () => VerifyOtpViewModel(verifyOtpUseCase: sl(), resendOtpUseCase: sl()),
  );
  sl.registerFactory(() => UserManagementViewModel());
  sl.registerFactory(() => AdminDashboardViewModel());
  sl.registerFactory(() => AdminNotificationsViewModel());
  sl.registerFactory(() => AdminReportsViewModel());
  sl.registerFactory(
    () => OperationalQueueViewModel(
      getManyWorkOrdersUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AssignWorkOrderViewModel(
      getTechniciansUseCase: sl(),
      assignWorkOrderUseCase: sl(),
    ),
  );
  sl.registerFactory(() => AssignedWorkOrderDetailViewModel());
  sl.registerFactory(() => ViewScheduleViewModel());
  sl.registerFactory(
    () => ReassignWorkOrderViewModel(reassignWorkOrderUseCase: sl()),
  );
  sl.registerFactory(
    () => ChangeAppointmentViewModel(changeAppointmentUseCase: sl()),
  );
  sl.registerFactory(
    () => RejectedWorkOrdersViewModel(
      getManyWorkOrdersUseCase: sl(),
      approveRefusalUseCase: sl(),
      denyRefusalUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => RejectionDetailViewModel(
      getSingleWorkOrderUseCase: sl(),
      approveRefusalUseCase: sl(),
      denyRefusalUseCase: sl(),
    ),
  );
  sl.registerFactory(() => ChooseRoleViewModel());
  sl.registerFactory(() => CreateAccountViewModel());
  sl.registerFactory(() => ProfileViewModel(sl(), sl()));
  sl.registerFactory(() => SecuritySettingsViewModel());
  sl.registerFactory(() => PartRequestsViewModel());
  sl.registerFactory(() => InventoryAssetsViewModel());
  sl.registerFactory(() => DetailRequestViewModel());
  sl.registerFactory(() => CustomerProfileViewModel(sl(), sl()));
  sl.registerFactory(() => PersonalInfoViewModel(sl()));
  sl.registerFactory(() => ServiceViewModel());
  sl.registerFactory(() => ChatViewModel(chatService: sl()));
  sl.registerFactory(() => CustomerSecurityViewModel());
  sl.registerFactory(() => CustomerNotificationsViewModel());
  sl.registerFactory(
    () => ProductsViewModel(
      getMyProductsUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => DetailedProductViewModel(
      getMyProductsUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(() => RequestServiceViewModel(sl()));
  sl.registerFactory(
    () => ActiveRepairsViewModel(getManyWorkOrdersUseCase: sl()),
  );
  sl.registerFactory(
    () => CustomerCancelWorkOrderViewModel(cancelWorkOrderUseCase: sl()),
  );
  sl.registerFactory(
    () => DetailedChatViewModel(chatService: sl(), getCurrentUserUseCase: sl()),
  );
  sl.registerFactory(() => DeviceRegistrationViewModel());
  sl.registerFactory(() => PartsViewModel());
  sl.registerFactory(() => NotificationsViewModel());

  // Tech ViewModels
  sl.registerFactory(() => TechnicianHomeViewModel());
  sl.registerFactory(
    () => TechWorkOrderViewModel(
      getManyWorkOrdersUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactoryParam<TechWorkOrderDetailsViewModel, String, void>(
    (workOrderId, _) => TechWorkOrderDetailsViewModel(
      workOrderId: workOrderId,
      getSingleWorkOrderUseCase: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerFactory(() => TechPauseWorkOrderViewModel());
  sl.registerFactory(() => TechRejectWorkOrderViewModel(sl(), sl(), sl()));
  sl.registerFactory(() => AddNewPartViewModel());
  sl.registerFactoryParam<CompleteWorkOrderViewModel, String, void>(
    (workOrderId, _) => CompleteWorkOrderViewModel(
      workOrderId: workOrderId,
      workOrderDraftUseCase: sl(),
      getSingleWorkOrderUseCase: sl(),
    ),
  );
  sl.registerFactory(() => TechProfileViewModel(sl(), sl()));
  sl.registerFactory(() => TechPersonalInfoViewModel(sl()));
  sl.registerFactory(() => TechNotificationsViewModel());
  sl.registerFactory(() => TechSecurityViewModel());
  sl.registerFactory(() => PartSearchViewModel());
  sl.registerFactory(
    () => WorkOrdersHistoryViewModel(
      getManyWorkOrdersUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactoryParam<DetailedHistoryViewModel, String, void>(
    (workOrderId, _) =>
        DetailedHistoryViewModel(repository: sl(), workOrderId: workOrderId),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(authRemoteService: sl(), authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<WorkOrderRepository>(
    () =>
        WorkOrderRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<WorkOrderLocalDataSource>(
    () => WorkOrderLocalDataSourceImpl(
      sharedPreferences: sl(),
      secureStorage: sl(),
    ),
  );
  sl.registerLazySingleton<WorkOrderRemoteDataSource>(
    () =>
        WorkOrderRemoteDataSourceImpl(client: sl(), authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl(), authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => ChatService(client: sl(), authLocalDataSource: sl()),
  );

  // --- External ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<http.Client>(
    () => InterceptedHttpClient(http.Client(), sl()),
  );
}
