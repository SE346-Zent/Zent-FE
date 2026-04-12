import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../account/widgets/customer_app_bar.dart';
import 'viewmodels/active_repairs_viewmodel.dart';

class ActiveRepairsScreen extends StatelessWidget {
  const ActiveRepairsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ActiveRepairsViewModel>(),
      child: const _ActiveRepairsView(),
    );
  }
}

class _ActiveRepairsView extends StatelessWidget {
  const _ActiveRepairsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ActiveRepairsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: const CustomerAppBar(
        title: 'Active Repairs',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Title & Tracking Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.spaceMd,
                left: AppDimens.spaceMd,
                right: AppDimens.spaceMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tracking Work Order',
                    style: TextStyles.display.copyWith(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    'Tracking your ongoing industrial service in real-time',
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.secondary500,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLg),

                  // Tracking Card
                  IntrinsicHeight(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.boraMd),
                        boxShadow: [BoxShadowStyles.raised],
                        border: const Border(
                          top: BorderSide(
                            color: AppColors.secondary300,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: AppColors.secondary300,
                            width: 1,
                          ),
                          right: BorderSide(
                            color: AppColors.secondary300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    AppDimens.spaceMd,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'WO-1234',
                                        style: TextStyles.bodyLarge.copyWith(
                                          color: AppColors.secondary400,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Mainboard Inspection',
                                        style: TextStyles.headline.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Scheduled time: 14h30',
                                        style: TextStyles.bodyMedium.copyWith(
                                          color: AppColors.secondary500,
                                        ),
                                      ),
                                      const SizedBox(height: AppDimens.spaceXl),
                                      _buildStepper(
                                        viewModel.currentStatusStep,
                                      ),
                                      const SizedBox(height: AppDimens.spaceXl),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildActionButton(
                                              'Cancel',
                                              AppColors.surface600,
                                              AppColors.secondary500,
                                              BoxShadowStyles.subtle,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: AppDimens.spaceMd,
                                          ),
                                          Expanded(
                                            child: _buildActionButton(
                                              'Edit',
                                              AppColors.tertiary500,
                                              Colors.white,
                                              BoxShadowStyles.glowing,
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
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary700,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(AppDimens.boraMd),
                                  bottomLeft: Radius.circular(AppDimens.boraMd),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXl),
                ],
              ),
            ),
          ),

          // Recent Completed List
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppDimens.spaceMd,
                right: AppDimens.spaceMd,
                bottom: AppDimens.spaceMd,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                  boxShadow: [BoxShadowStyles.subtle],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                        vertical: AppDimens.spaceSm,
                      ),
                      child: Text('Recent Completed', style: TextStyles.middle),
                    ),
                    const Divider(height: 1, color: AppColors.secondary50),

                    // List item
                    Column(
                      children: [
                        for (
                          int i = 0;
                          i < viewModel.recentCompleted.length;
                          i++
                        ) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.spaceMd,
                              vertical: AppDimens.spaceSm,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      viewModel.recentCompleted[i].title,
                                      style: TextStyles.bodyLarge.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                    ),
                                    Text(
                                      viewModel.recentCompleted[i].woNumber,
                                      style: TextStyles.label.copyWith(
                                        color: AppColors.secondary300,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  viewModel.recentCompleted[i].date,
                                  style: TextStyles.label.copyWith(
                                    color: AppColors.secondary500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (i < viewModel.recentCompleted.length - 1)
                            const Divider(
                              height: 1,
                              color: AppColors.secondary50,
                            ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepItem(
          Icons.assignment_outlined,
          'Ticket Open',
          1,
          currentStep,
        ),
        _buildStepLine(2, currentStep),
        _buildStepItem(
          Icons.person_add_alt_1_outlined,
          'Tech Assigned',
          2,
          currentStep,
        ),
        _buildStepLine(3, currentStep),
        _buildStepItem(
          Icons.build_circle_outlined,
          'In Progress',
          3,
          currentStep,
        ),
        _buildStepLine(4, currentStep),
        _buildStepItem(Icons.check_circle_outline, 'Done', 4, currentStep),
      ],
    );
  }

  Widget _buildStepItem(
    IconData icon,
    String label,
    int stepIndex,
    int currentStep,
  ) {
    final isActive = stepIndex <= currentStep;
    final color = isActive ? AppColors.tertiary500 : AppColors.secondary300;

    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : AppColors.secondary100,
            ),
            child: Icon(icon, size: 20, color: isActive ? Colors.white : color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyles.label.copyWith(
              color: isActive ? AppColors.tertiary500 : AppColors.secondary400,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int stepIndex, int currentStep) {
    final isActive = stepIndex <= currentStep;
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(top: 18),
        height: 2,
        color: isActive ? AppColors.tertiary500 : AppColors.secondary200,
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    Color bgColor,
    Color textColor,
    BoxShadow shadow,
  ) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [shadow],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
        ),
        onPressed: () {},
        child: Text(title, style: TextStyles.title.copyWith(color: textColor)),
      ),
    );
  }
}
