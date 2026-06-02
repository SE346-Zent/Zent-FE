import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/notifications/viewmodels/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/common/notifications/notification_navigator.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'viewmodels/technician_home_viewmodel.dart';
import 'widgets/tech_home_header.dart';
import 'widgets/tech_stats_row.dart';
import 'widgets/schedule_item_card.dart';

class TechnicianHomeScreen extends StatelessWidget {
  const TechnicianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<TechnicianHomeViewModel>()..fetchTodaySchedule(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => di.sl<NotificationsViewModel>()..fetchUnreadCount(),
          ),
        ],
        child: const _TechnicianHomeContent(),
      ),
    );
  }
}

class _TechnicianHomeContent extends StatefulWidget {
  const _TechnicianHomeContent();

  @override
  State<_TechnicianHomeContent> createState() => _TechnicianHomeContentState();
}

class _TechnicianHomeContentState extends State<_TechnicianHomeContent> {
  bool _pendingProcessed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_pendingProcessed) {
      _pendingProcessed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final role = context.read<AuthViewModel>().role;
        NotificationNavigator.processPendingNotification(context, role);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechnicianHomeViewModel>();

    return Material(
      color: AppColors.background500,
      child: Stack(
        children: [
          // Background Layer with Logo
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                AppAssets.blackLogo,
                width: 179,
                height: 229,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) => TechHomeHeader(
                    userName: viewModel.userName,
                    onMenuTapped: () {
                      Scaffold.of(context).openDrawer();
                    },
                    onProfileTapped: () {
                      try {
                        StatefulNavigationShell.of(context).goBranch(3);
                      } catch (e) {
                        debugPrint('Error navigating to profile: $e');
                      }
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (viewModel.isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimens.spaceXl,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.tertiary500,
                              ),
                            ),
                          )
                        else if (viewModel.todaySchedule.isEmpty)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppDimens.spaceMd,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.spaceXl,
                              horizontal: AppDimens.spaceMd,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface100,
                              borderRadius: BorderRadius.circular(
                                AppDimens.boraMd,
                              ),
                              border: Border.all(color: AppColors.secondary50),
                              boxShadow: [BoxShadowStyles.subtle],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.secondary300,
                                  size: 40.0,
                                ),
                                const SizedBox(height: AppDimens.spaceSm),
                                Text(
                                  "No scheduled jobs today",
                                  style: TextStyles.title.copyWith(
                                    color: AppColors.secondary400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.spaceMd,
                            ),
                            itemCount: viewModel.todaySchedule.length,
                            itemBuilder: (context, index) {
                              final item = viewModel.todaySchedule[index];
                              return ScheduleItemCard(
                                item: item,
                                onTap: () {
                                  if (item.id.isNotEmpty) {
                                    context.pushNamed(
                                      RouteNames.techWorkOrderDetails,
                                      pathParameters: {'workOrderId': item.id},
                                    );
                                  } else {
                                    debugPrint(
                                      "action triggered: tap on mock item ${item.title}",
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        const SizedBox(height: AppDimens.spaceLg),
                        TechStatsRow(
                          jobsDone: viewModel.jobsDone,
                          averageRating: viewModel.averageRating,
                        ),
                        const SizedBox(height: AppDimens.spaceXl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
