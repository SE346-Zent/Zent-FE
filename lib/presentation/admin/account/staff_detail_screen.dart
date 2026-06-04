import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'package:zent_fe/presentation/admin/account/viewmodels/staff_detail_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_success_popup.dart';
import 'package:zent_fe/presentation/technician/account/widgets/tech_text_field.dart';

class StaffDetailScreen extends StatelessWidget {
  final String userId;

  const StaffDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<StaffDetailViewModel>(param1: userId),
      child: const _StaffDetailContent(),
    );
  }
}

class _StaffDetailContent extends StatefulWidget {
  const _StaffDetailContent();

  @override
  State<_StaffDetailContent> createState() => _StaffDetailContentState();
}

class _StaffDetailContentState extends State<_StaffDetailContent>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _showDisableConfirmation(
      BuildContext context, StaffDetailViewModel viewModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Center(
          child: Text(
            'Disable Account',
            style: TextStyles.headline.copyWith(
              color: AppColors.error500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Text(
          'Are you sure you want to disable this account?',
          textAlign: TextAlign.center,
          style: TextStyles.bodyLarge.copyWith(
            color: AppColors.primary500,
            fontWeight: FontWeight.w600,
          ),
        ),
        actionsPadding: const EdgeInsets.all(AppDimens.spaceMd),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondary200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'No',
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final success = await viewModel.disableAccount();
                    if (success && context.mounted) {
                      ZentSuccessPopup.show(context, 'Account disabled successfully');
                      Navigator.pop(context); // Back to list
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to disable account')),
                      );
                    }
                  },
                  child: Text(
                    'Yes',
                    style: TextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StaffDetailViewModel>();
    final user = viewModel.staffUser;

    if (viewModel.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background500,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background500,
        body: SafeArea(
          child: Column(
            children: [
              const AccountHeader(title: 'Staff Detail', showDivider: true),
              Expanded(
                child: Center(
                  child: Text(
                    viewModel.errorMsg.isNotEmpty
                      ? viewModel.errorMsg
                      : 'Staff member not found.',
                    style: TextStyles.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isTech = user.role == UserRoles.technician;
    final staffCode = user.employeeId != null && user.employeeId!.isNotEmpty
        ? '#${user.employeeId}'
        : '#${user.id}';

    if (isTech && _tabController == null) {
      _tabController = TabController(length: 2, vsync: this);
    }

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            AccountHeader(
              title: 'Staff Detail',
              subtitle: staffCode,
              showDivider: true,
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: AppColors.primary500),
                onSelected: (val) {
                  if (val == 'disable') {
                    _showDisableConfirmation(context, viewModel);
                  }
                },
                offset: const Offset(-138, 40),
                elevation: 0,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                constraints: const BoxConstraints(maxWidth: 162, minWidth: 162),
                padding: EdgeInsets.zero,
                itemBuilder: (ctx) => [
                  PopupMenuItem<String>(
                    value: 'disable',
                    height: 28,
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: 162.0,
                      height: 28.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.error50,
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
                      child: Text(
                        'Disable Account',
                        style: TextStyles.label.copyWith(
                          color: AppColors.error500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: UserAvatar(
                avatarUrl: user.avatarUrl,
                name: user.name,
                size: 110,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              user.name,
              style: TextStyles.display.copyWith(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              user.email,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.secondary300,
              ),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            if (isTech && _tabController != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.secondary100, width: 1.0),
                    ),
                  ),
                  child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.tertiary500,
                  unselectedLabelColor: AppColors.secondary300,
                  indicatorColor: AppColors.tertiary500,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 18),
                          SizedBox(width: 6),
                          Text('Account Information'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.work_outline, size: 18),
                          SizedBox(width: 6),
                          Text('Work Performance'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAccountInfo(user),
                    _buildWorkPerformance(viewModel),
                  ],
                ),
              ),
            ] else ...[
              const Divider(color: AppColors.secondary50),
              Expanded(
                child: _buildAccountInfo(user),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfo(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        children: [
          TechTextField(
            label: 'Full name',
            hint: 'Full name',
            controller: TextEditingController(text: user.name),
            readOnly: true,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          TechTextField(
            label: 'Employee ID',
            hint: 'Employee ID',
            controller: TextEditingController(text: user.employeeId ?? ''),
            readOnly: true,
            prefixIcon: Icons.work_outline,
            suffixIcon: Icons.lock,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          TechTextField(
            label: 'Email Address',
            hint: 'Email Address',
            controller: TextEditingController(text: user.email),
            readOnly: true,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          TechTextField(
            label: 'Phone number',
            hint: '',
            controller: TextEditingController(text: user.phoneNumber),
            readOnly: true,
            prefixIcon: Icons.phone_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkPerformance(StaffDetailViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: viewModel.performanceRatings.entries.map((entry) {
        return PerformanceRatingBar(
          label: entry.key,
          value: entry.value,
        );
      }).toList(),
    );
  }
}

class PerformanceRatingBar extends StatelessWidget {
  final String label;
  final double value;

  const PerformanceRatingBar({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          SizedBox(
            width: 80.0,
            child: Text(
              label,
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.secondary500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.5),
              child: SizedBox(
                height: 3.0,
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.primary500,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.tertiary500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          SizedBox(
            width: 45.0,
            child: Text(
              '${(value * 100).toInt()}%',
              textAlign: TextAlign.end,
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.secondary500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
