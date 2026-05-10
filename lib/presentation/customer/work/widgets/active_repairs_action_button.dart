import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ActiveRepairsActionButton extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  final BoxShadow shadow;
  final VoidCallback onTap;

  const ActiveRepairsActionButton({
    super.key,
    required this.title,
    required this.bgColor,
    required this.textColor,
    required this.shadow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [shadow],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
        ),
        onPressed: onTap,
        child: Text(title, style: TextStyles.title.copyWith(color: textColor)),
      ),
    );
  }
}
