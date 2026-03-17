import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

class TwoFactorAuthToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const TwoFactorAuthToggle({
    super.key,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<TwoFactorAuthToggle> createState() => _TwoFactorAuthToggleState();
}

class _TwoFactorAuthToggleState extends State<TwoFactorAuthToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onToggle(bool newValue) {
    setState(() {
      _value = newValue;
    });
    widget.onChanged(newValue);
    debugPrint("action triggered: _onToggle to $newValue");
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () => _onToggle(!_value),
          child: Container(
            width: 58.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.boraLg),
              color: _value ? AppColors.tertiary500 : AppColors.secondary200,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
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
  }
}
