import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
import 'package:zent_fe/di/injection_container.dart' as di;
import 'view_models/technician_home_viewmodel.dart';
import 'widgets/tech_home_header.dart';
import 'widgets/tech_stats_row.dart';
import 'widgets/schedule_item_card.dart';

class TechnicianHomeScreen extends StatelessWidget {
  const TechnicianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<TechnicianHomeViewModel>(),
      child: const _TechnicianHomeContent(),
    );
  }
}

class _TechnicianHomeContent extends StatelessWidget {
  const _TechnicianHomeContent();

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
                                debugPrint(
                                  "action triggered: tap on ${item.title}",
                                );
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
