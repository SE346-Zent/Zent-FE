import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'security_card_container.dart';
import 'security_section_title.dart';
import 'two_factor_auth_toggle.dart';
import '../viewmodel/security_settings_viewmodel.dart';

class TwoFactorSection extends StatelessWidget {
  final SecuritySettingsData securityData;
  final ValueChanged<bool> onToggle;

  const TwoFactorSection({
    super.key,
    required this.securityData,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SecuritySectionTitle(
          title: 'Two-Factor Authentication',
          iconData: Icons.security_outlined,
          iconColor: AppColors.tertiary500,
          iconSize: 20.0,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        SecurityCardContainer(
          child: TwoFactorAuthToggle(
            initialValue: securityData.isTwoFactorEnabled,
            onChanged: onToggle,
          ),
        ),
      ],
    );
  }
}
