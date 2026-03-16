import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/text_styles.dart';
import '../../../common/core/themes/dimens.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TwoFactorToggleCubit extends Cubit<bool> {
  TwoFactorToggleCubit(super.initialValue);
  void toggle() => emit(!state);
}

class TwoFactorAuthToggle extends StatelessWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const TwoFactorAuthToggle({
    super.key,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TwoFactorToggleCubit(initialValue),
      child: BlocBuilder<TwoFactorToggleCubit, bool>(
        builder: (context, isEnabled) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable 2FA',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Text(
                      'Add an extra layer of security to your account by requiring a code from your mobile device when logging in.',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              GestureDetector(
                onTap: () {
                  context.read<TwoFactorToggleCubit>().toggle();
                  onChanged(!isEnabled);
                  debugPrint("action triggered: _onToggle to ${!isEnabled}");
                },
                child: Container(
                  width: 58.0,
                  height: 28.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.boraLg),
                    color: isEnabled ? AppColors.tertiary500 : AppColors.secondary200,
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface100, // #FFFFFF
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
