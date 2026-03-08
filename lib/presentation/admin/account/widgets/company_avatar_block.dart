import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';

class CompanyAvatarBlock extends StatelessWidget {
  final String avatarUrl;
  final VoidCallback onEditTap;

  const CompanyAvatarBlock({
    super.key,
    required this.avatarUrl,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118.0,
      height: 118.0,
      child: Stack(
        children: [
          Container(
            width: 118.0,
            height: 118.0,
            decoration: const BoxDecoration(
              color: AppColors.tertiary400,
              shape: BoxShape.circle,
            ),
            child: ClipOval(child: Image.network(avatarUrl, fit: BoxFit.cover)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: AppColors.tertiary500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background500,
                    width: 3.0,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.edit,
                  color: AppColors.surface100, // #FFFFFF
                  size: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
