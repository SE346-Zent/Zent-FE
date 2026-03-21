import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class AddUserFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddUserFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 61.0,
      height: 61.0,
      margin: const EdgeInsets.only(bottom: 24.0, right: 8.0),
      decoration: BoxDecoration(
        color: AppColors.tertiary400,
        shape: BoxShape.circle,
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onPressed,
          child: const Center(
            child: Icon(Icons.add, size: 32.0, color: AppColors.surface100),
          ),
        ),
      ),
    );
  }
}
