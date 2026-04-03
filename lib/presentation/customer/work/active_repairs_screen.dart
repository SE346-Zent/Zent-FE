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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                  boxShadow: [BoxShadowStyles.raised],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary700,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimens.boraMd),
                          bottomLeft: Radius.circular(AppDimens.boraMd),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.spaceLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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

                            // Custom Stepper
                            _buildStepper(viewModel.currentStatusStep),

                            const SizedBox(height: AppDimens.spaceXl),

                            // Action Buttons
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
                                const SizedBox(width: AppDimens.spaceMd),
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
              ),
            ),
            const SizedBox(height: AppDimens.spaceXl),

            // Recent Completed List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimens.boraMd),
                boxShadow: [BoxShadowStyles.subtle],
                border: Border.all(color: AppColors.secondary100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Text(
                      'Recent Completed',
                      style: TextStyles.headline.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.secondary100),

                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: viewModel.recentCompleted.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        color: AppColors.secondary100,
                      ),
                      itemBuilder: (context, index) {
                        final item = viewModel.recentCompleted[index];
                        return Padding(
                          padding: const EdgeInsets.all(AppDimens.spaceMd),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyles.bodyLarge.copyWith(
                                      color: AppColors.secondary700,
                                    ),
                                  ),
                                  Text(
                                    item.woNumber,
                                    style: TextStyles.label.copyWith(
                                      color: AppColors.secondary400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item.date,
                                style: TextStyles.bodyMedium.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        onPressed: () {}, // TODO: Handle action
        child: Text(title, style: TextStyles.title.copyWith(color: textColor)),
      ),
    );
  }
}
