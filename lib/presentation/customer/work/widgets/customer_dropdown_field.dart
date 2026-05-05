import 'package:flutter/material.dart';
import '../../../../presentation/common/core/themes/boxshadow.dart';
import '../../../../presentation/common/core/themes/colors.dart';
import '../../../../presentation/common/core/themes/dimens.dart';
import '../../../../presentation/common/core/themes/text_styles.dart';

class CustomerDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;
  final bool readOnly;
  final String? hint;

  const CustomerDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.readOnly = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceXs),
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyles.title.copyWith(color: AppColors.primary500),
              children: isRequired
                  ? [
                      TextSpan(
                        text: '*',
                        style: TextStyles.title.copyWith(
                          color: AppColors.error500,
                        ),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: readOnly ? AppColors.secondary50 : AppColors.surface100,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100, width: 1.0),
            boxShadow: [BoxShadowStyles.subtle],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: hint != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        hint!,
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                    )
                  : null,
              items: items,
              onChanged: readOnly ? null : onChanged,
              icon: const Padding(
                padding: EdgeInsets.only(right: AppDimens.spaceSm),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.secondary100,
                ),
              ),
              dropdownColor: AppColors.surface100,
              style: TextStyles.bodyLarge.copyWith(color: AppColors.primary500),
              padding: const EdgeInsets.only(left: AppDimens.spaceSm),
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
              elevation: 4,
              menuMaxHeight: 300,
            ),
          ),
        ),
      ],
    );
  }
}
