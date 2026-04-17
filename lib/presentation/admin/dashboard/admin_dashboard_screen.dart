import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/admin_dashboard_viewmodel.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AdminDashboardViewModel>(),
      child: const _AdminDashboardScreenContent(),
    );
  }
}

class _AdminDashboardScreenContent extends StatelessWidget {
  const _AdminDashboardScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminDashboardViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: AppBar(
        backgroundColor: AppColors.primary500,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Zent',
          style: TextStyles.headline.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.0),
              boxShadow: [BoxShadowStyles.raised],
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, ${viewModel.userName}',
                          style: TextStyles.label.copyWith(
                            color: AppColors.secondary300,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXs),
                        RichText(
                          text: TextSpan(
                            style: TextStyles.title.copyWith(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              const TextSpan(text: 'Welcome back to\n'),
                              TextSpan(
                                text: 'Dashboard',
                                style: TextStyles.title.copyWith(
                                  color: AppColors.tertiary500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary500,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [BoxShadowStyles.subtle],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.0),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.person_add_alt_1,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Manage user',
                                            style: TextStyles.title.copyWith(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceMd),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [BoxShadowStyles.subtle],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.0),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.assignment_add,
                                            color: AppColors.primary500,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Assign Jobs',
                                            style: TextStyles.title.copyWith(
                                              color: AppColors.primary500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [BoxShadowStyles.subtle],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  width: 6.0,
                                  color: AppColors.tertiary500,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimens.spaceMd,
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Active jobs',
                                              style: TextStyles.title.copyWith(
                                                color: AppColors.secondary500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppDimens.spaceSm,
                                            ),
                                            Text(
                                              '${viewModel.activeJobs}',
                                              style: TextStyles.display
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.call_made,
                                              color: AppColors.success500,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4.0),
                                            Text(
                                              '${viewModel.activeJobsTrend.toInt()}%',
                                              style: TextStyles.label.copyWith(
                                                color: AppColors.success500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMd),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [BoxShadowStyles.subtle],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  width: 6.0,
                                  color: AppColors.secondary300,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimens.spaceMd,
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Overall ratings',
                                              style: TextStyles.title.copyWith(
                                                color: AppColors.secondary500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppDimens.spaceSm,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  '${viewModel.overallRating}',
                                                  style: TextStyles.display
                                                      .copyWith(
                                                        color: Colors.black,
                                                      ),
                                                ),
                                                Text(
                                                  '/5.0',
                                                  style: TextStyles.title
                                                      .copyWith(
                                                        color: AppColors
                                                            .secondary300,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.call_received,
                                              color: AppColors.error500,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4.0),
                                            Text(
                                              '${viewModel.ratingTrend.abs().toInt()}%',
                                              style: TextStyles.label.copyWith(
                                                color: AppColors.error500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),
                        Expanded(
                          child: Center(
                            child: Opacity(
                              opacity: 0.5,
                              child: Image.asset(
                                AppAssets.blackLogo,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
