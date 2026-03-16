import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/dimens.dart';
import '../themes/text_styles.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final IconData leadingIcon;
  final bool isReadOnly;
  final String? helperText;

  const InputField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    required this.leadingIcon,
    this.isReadOnly = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.middle.copyWith(color: AppColors.secondary500),
        ),
        const SizedBox(height: AppDimens.spaceXs), // 8px bottom margin from label
        Container(
          height: 48.0,
          decoration: BoxDecoration(
            color: isReadOnly ? AppColors.secondary50 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.boraMd), // Assuming standard radius
            border: Border.all(color: AppColors.secondary200, width: 1.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                child: Icon(leadingIcon, color: AppColors.secondary300, size: 20.0),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: initialValue,
                  onChanged: onChanged,
                  readOnly: isReadOnly,
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.primary500),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
              if (isReadOnly)
                const Padding(
                  padding: EdgeInsets.only(right: AppDimens.spaceMd),
                  child: SizedBox(
                    width: 17.0,
                    height: 17.0,
                    child: Icon(Icons.lock_outline, color: AppColors.secondary200, size: 17.0),
                  ),
                ),
            ],
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            helperText!,
            style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary500),
          ),
        ],
      ],
    );
  }
}
