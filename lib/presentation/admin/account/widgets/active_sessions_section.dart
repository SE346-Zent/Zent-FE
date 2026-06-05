import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/user_session.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ActiveSessionsSection extends StatelessWidget {
  final List<UserSession> sessions;
  final bool isLoading;
  final Function(String sessionId) onRevoke;
  final VoidCallback onRevokeAllOthers;

  const ActiveSessionsSection({
    super.key,
    required this.sessions,
    required this.isLoading,
    required this.onRevoke,
    required this.onRevokeAllOthers,
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

  IconData _getDeviceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('iphone') || lower.contains('ios')) {
      return Icons.phone_iphone_outlined;
    }
    if (lower.contains('android') ||
        lower.contains('phone') ||
        lower.contains('mobile')) {
      return Icons.phone_android_outlined;
    }
    if (lower.contains('windows') ||
        lower.contains('mac') ||
        lower.contains('linux') ||
        lower.contains('desktop') ||
        lower.contains('pc')) {
      return Icons.desktop_windows_outlined;
    }
    return Icons.devices_other_outlined;
  }

  void _showRevokeConfirmation(BuildContext context, UserSession session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Session?'),
        content: Text(
          'Are you sure you want to log out of "${session.deviceName}" (${session.ipAddress})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onRevoke(session.id);
            },
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }

  void _showRevokeAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke All Other Sessions?'),
        content: const Text(
          'Are you sure you want to log out of all other active sessions? You will remain logged in on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onRevokeAllOthers();
            },
            child: const Text('Revoke All Others'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasOthers = sessions.any((s) => !s.isCurrent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.devices_outlined,
                    color: AppColors.tertiary500,
                    size: 24.0,
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  Text(
                    'Active Sessions',
                    style: TextStyles.title.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                ],
              ),
              if (!isLoading && hasOthers)
                TextButton.icon(
                  onPressed: () => _showRevokeAllConfirmation(context),
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 16.0,
                    color: AppColors.error500,
                  ),
                  label: Text(
                    'Revoke Others',
                    style: TextStyles.label.copyWith(
                      color: AppColors.error500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceSm,
                      vertical: AppDimens.spaceXs,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 280),
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100, width: 1.5),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.tertiary500,
                    ),
                  ),
                )
              : sessions.isEmpty
              ? const SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      'No active sessions found',
                      style: TextStyle(color: AppColors.secondary400),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: sessions.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.secondary100,
                    height: AppDimens.spaceLg,
                  ),
                  itemBuilder: (context, index) {
                    final item = sessions[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          _getDeviceIcon(item.deviceName),
                          color: item.isCurrent
                              ? AppColors.tertiary500
                              : AppColors.secondary400,
                          size: 28.0,
                        ),
                        const SizedBox(width: AppDimens.spaceMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.deviceName,
                                      style: TextStyles.bodyLarge.copyWith(
                                        color: AppColors.primary500,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (item.isCurrent) ...[
                                    const SizedBox(width: AppDimens.spaceSm),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0,
                                        vertical: 2.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        border: Border.all(
                                          color: Colors.green.shade300,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.boraXs,
                                        ),
                                      ),
                                      child: Text(
                                        'Current',
                                        style: TextStyles.label.copyWith(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                '${item.ipAddress} • ${_formatDate(item.createdAt)}',
                                style: TextStyles.label.copyWith(
                                  color: AppColors.secondary400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!item.isCurrent) ...[
                          const SizedBox(width: AppDimens.spaceSm),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: AppColors.error500,
                              size: 22.0,
                            ),
                            onPressed: () =>
                                _showRevokeConfirmation(context, item),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
