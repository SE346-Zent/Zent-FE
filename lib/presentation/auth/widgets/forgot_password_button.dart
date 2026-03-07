import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        // Use declarative routing
        onPressed: () => context.go('${Routes.login}/${Routes.forgetPassword}'),
        child: Text(
          'Forgot Password?',
          style: TextStyles.label.copyWith(
            color: AppColors.tertiary500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}