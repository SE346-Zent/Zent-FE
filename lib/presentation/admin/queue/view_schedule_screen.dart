import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/view_schedule_viewmodel.dart';

class ViewScheduleScreen extends StatelessWidget {
  final String techId;

  const ViewScheduleScreen({super.key, required this.techId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ViewScheduleViewModel>()..initData(techId),
      child: const _ViewScheduleScreenContent(),
    );
  }
}

class _ViewScheduleScreenContent extends StatelessWidget {
  const _ViewScheduleScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ViewScheduleViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: AppColors.background500,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'View Schedule',
                style: TextStyles.headline.copyWith(
                  color: AppColors.primary500,
                ),
              ),
              centerTitle: true,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondary50,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(viewModel),
              const SizedBox(height: AppDimens.spaceLg),
              _buildCalendarHeader(),
              const SizedBox(height: AppDimens.spaceMd),
              _buildCalendarStrip(viewModel),
              const SizedBox(height: AppDimens.spaceLg),
              ...viewModel.workOrders.map((wo) => _buildJobCard(wo)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(ViewScheduleViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary300, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              viewModel.technician['avatar'],
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 56,
                  height: 56,
                  color: AppColors.secondary200,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.technician['name'],
                  style: TextStyles.title.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 4.0),
                Text(
                  viewModel.technician['email'],
                  style: TextStyles.bodyLarge.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${viewModel.technician['rating']}',
                  style: TextStyles.bodyLarge.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '/5.0',
                  style: TextStyles.label.copyWith(
                    color: AppColors.secondary300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'April 22',
          style: TextStyles.middle.copyWith(color: Colors.black),
        ),
        const Icon(Icons.calendar_today_outlined, color: Colors.black),
      ],
    );
  }

  Widget _buildCalendarStrip(ViewScheduleViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary400),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: viewModel.scheduleDays.asMap().entries.map((entry) {
          final index = entry.key;
          final dayData = entry.value;
          final isSelected = index == viewModel.selectedDateIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => viewModel.selectDate(index),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondary700
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimens.boraMd - 1),
                ),
                child: Column(
                  children: [
                    Text(
                      dayData['day'],
                      style: TextStyles.middle.copyWith(
                        color: isSelected ? Colors.white : AppColors.primary500,
                      ),
                    ),
                    Text(
                      dayData['date'],
                      style: TextStyles.bodyLarge.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.secondary500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 6.0, color: AppColors.tertiary500),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.spaceLg,
                  right: AppDimens.spaceLg,
                  bottom: AppDimens.spaceLg,
                  top: AppDimens.spaceSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['id'],
                      style: TextStyles.title.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      data['deviceName'],
                      style: TextStyles.headline.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildIconTextRow(Icons.person_outline, data['customer']),
                    const SizedBox(height: 6.0),
                    _buildIconTextRow(
                      Icons.location_on_outlined,
                      data['location'],
                    ),
                    const SizedBox(height: 6.0),
                    _buildIconTextRow(
                      Icons.calendar_today_outlined,
                      data['time'],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.secondary400),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyles.label.copyWith(color: AppColors.secondary500),
          ),
        ),
      ],
    );
  }
}
