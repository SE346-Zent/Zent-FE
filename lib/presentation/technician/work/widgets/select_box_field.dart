import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

import 'package:zent_fe/presentation/common/core/ui/input_field.dart';

class SelectBoxField extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> dropdownItems;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final TextAlign textAlign;
  final IconData? leadingIcon;
  final Color? labelColor;

  const SelectBoxField({
    super.key,
    required this.label,
    required this.hintText,
    required this.dropdownItems,
    required this.selectedValue,
    required this.onChanged,
    this.textAlign = TextAlign.start,
    this.leadingIcon,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InputField(
      label: label,
      hintText: hintText,
      leadingIcon: leadingIcon,
      labelColor: labelColor,
      customInputChild: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          dropdownColor: AppColors.surface100,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          items: dropdownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                textAlign: textAlign,
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.secondary300,
          ),
          isExpanded: true,
          alignment: textAlign == TextAlign.center
              ? Alignment.center
              : Alignment.centerLeft,
          hint: Text(
            hintText,
            textAlign: textAlign,
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary300),
          ),
        ),
      ),
    );
  }
}
