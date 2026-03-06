import 'package:flutter/material.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_primary_button.dart';
import '../common/core/themes/colors.dart';
import '../common/core/themes/dimens.dart';
import '../common/core/themes/text_styles.dart';
import 'reset_successfully_screen.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      
      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reset Password',
          style: TextStyles.title.copyWith(
            color: AppColors.primary500,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      
      body: SafeArea(
        child: Column(
          children: [
            // Rollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: 'Create New Password',
                      subtitle: 'Your new password must be different from previously used password',
                      showLogo: false,
                      isCenter: false,
                    ),
                    
                    const SizedBox(height: AppDimens.spaceXl),

                    const AuthTextField(
                      label: 'New Password',
                      hintText: 'Enter your new password',
                      isPassword: true,
                    ),

                    const SizedBox(height: AppDimens.spaceSm),

                    // THANH ĐO ĐỘ MẠNH MẬT KHẨU
                    _buildPasswordStrengthIndicator(),

                    const SizedBox(height: AppDimens.spaceLg),

                    const AuthTextField(
                      label: 'Confirm Password',
                      hintText: 'Confirm new password',
                      isPassword: true,
                    ),

                    const SizedBox(height: AppDimens.spaceLg),

                    // HỘP KIỂM TRA ĐIỀU KIỆN MẬT KHẨU
                    _buildPasswordRequirementsBox(),

                    const SizedBox(height: AppDimens.spaceXl),

                    AuthPrimaryButton(
                      text: 'Reset Password',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResetSuccessfullyScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // PHẦN 2: LOGO CỐ ĐỊNH Ở ĐÁY
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ZentAvatar.png', height: 28, fit: BoxFit.contain),
                  const SizedBox(width: AppDimens.spaceSm),
                  Text(
                    'ZENT',
                    style: TextStyles.title.copyWith(
                      letterSpacing: 1.5,
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET CON: THANH ĐO ĐỘ MẠNH MẬT KHẨU
  Widget _buildPasswordStrengthIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Password Strength', style: TextStyles.label.copyWith(color: AppColors.secondary400)),
            Text('weak', style: TextStyles.label.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Row(
          children: [
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.secondary200, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.secondary200, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.secondary200, borderRadius: BorderRadius.circular(2)))),
          ],
        ),
      ],
    );
  }

  // WIDGET CON: HỘP ĐIỀU KIỆN MẬT KHẨU
  Widget _buildPasswordRequirementsBox() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Password requirements:', style: TextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimens.spaceSm),
          _buildRequirementItem('At least 8 characters long'),
          const SizedBox(height: AppDimens.spaceXs),
          _buildRequirementItem('Contains at least one number'),
          const SizedBox(height: AppDimens.spaceXs),
          _buildRequirementItem('Contains at least one special character'),
        ],
      ),
    );
  }

  // WIDGET CON: DÒNG ĐIỀU KIỆN (CÓ ICON TRÒN TỪNG DÒNG)
  Widget _buildRequirementItem(String text) {
    return Row(
      children: [
        Icon(Icons.circle_outlined, size: 16, color: AppColors.secondary400),
        const SizedBox(width: AppDimens.spaceSm),
        Text(text, style: TextStyles.label.copyWith(color: AppColors.secondary400)),
      ],
    );
  }
}