import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/admin/account/blocs/two_factor_cubit.dart';
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
    return BlocProvider(
      create: (context) => TwoFactorCubit(securityData.isTwoFactorEnabled),
      child: BlocListener<TwoFactorCubit, bool>(
        listener: (context, isEnabled) {
          onToggle(isEnabled);
        },
        child: Column(
          children: [
            const SecuritySectionTitle(
              title: 'Two-Factor Authentication',
              iconData: Icons.security_outlined,
              iconColor: AppColors.tertiary500,
              iconSize: 28.0,
            ),
            const SizedBox(height: AppDimens.spaceMd),
            SecurityCardContainer(
              child: BlocBuilder<TwoFactorCubit, bool>(
                builder: (context, isEnabled) {
                  return TwoFactorAuthToggle(
                    initialValue: isEnabled,
                    onChanged: (value) =>
                        context.read<TwoFactorCubit>().toggle(value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
