import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'social_login_button.dart'; // Import child widget

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider Section
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.secondary200)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Or continue with', style: TextStyles.label),
            ),
            Expanded(child: Divider(color: AppColors.secondary200)),
          ],
        ),

        const SizedBox(height: AppDimens.spaceLg),

        // Google Button
        SocialLoginButton(
          onPressed: () {
            // TODO: Handle Google Login logic
          },
        ),
      ],
    );
  }
}
