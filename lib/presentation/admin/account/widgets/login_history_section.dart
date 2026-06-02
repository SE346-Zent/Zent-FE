import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/login_history_entry.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class LoginHistorySection extends StatelessWidget {
  final List<LoginHistoryEntry> history;
  final bool isLoading;

  const LoginHistorySection({
    super.key,
    required this.history,
    required this.isLoading,
  });

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthStr = months[dt.month - 1];
    final dayStr = dt.day.toString();
    final hourStr = dt.hour.toString().padLeft(2, '0');
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    return '$monthStr $dayStr, $hourStr:$minuteStr';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              const Icon(
                Icons.history_outlined,
                color: AppColors.tertiary500,
                size: 24.0,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                'Login History',
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 220),
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.tertiary500,
                    ),
                  ),
                )
              : history.isEmpty
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No login history available',
                      style: TextStyle(color: AppColors.secondary400),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: history.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.secondary100,
                    height: AppDimens.spaceLg,
                  ),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final locationStr =
                        item.location != null && item.location!.isNotEmpty
                        ? '${item.location} (${item.ipAddress})'
                        : item.ipAddress;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.deviceName,
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.primary500,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                locationStr,
                                style: TextStyles.label.copyWith(
                                  color: AppColors.secondary400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatDate(item.createdAt),
                          style: TextStyles.label.copyWith(
                            color: AppColors.secondary400,
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
