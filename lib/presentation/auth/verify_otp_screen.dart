import 'package:flutter/material.dart';
import 'widgets/auth_primary_button.dart';
import '../common/core/themes/colors.dart';
import '../common/core/themes/dimens.dart';
import '../common/core/themes/text_styles.dart';
import 'create_new_password_screen.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      
      // APP BAR WITH BACK BUTTON AND TITLE
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verification',
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
            // PHẦN 2: NỘI DUNG CHÍNH (CUỘN ĐƯỢC)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDimens.spaceXl),

                    Image.asset('assets/images/VerifyOTP1.png', height: 100),

                    const SizedBox(height: AppDimens.spaceXl),

                    Text(
                      'Verify OTP',
                      style: TextStyles.display.copyWith(color: AppColors.primary500),
                    ),

                    const SizedBox(height: AppDimens.spaceSm),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
                        children: [
                          const TextSpan(text: 'The OTP code has been sent to\n'),
                          TextSpan(
                            text: 'name@gmail.com',
                            style: const TextStyle(
                              color: AppColors.tertiary500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    // KHU VỰC 6 Ô NHẬP OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6, 
                        (index) => _buildOtpBox(''),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
                        children: [
                          const TextSpan(text: 'Haven\'t received OTP Code? '),
                          TextSpan(
                            text: 'Resend',
                            style: const TextStyle(
                              color: AppColors.tertiary500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    AuthPrimaryButton(
                      text: 'Send →',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateNewPasswordScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // PHẦN 3: LOGO CỐ ĐỊNH Ở ĐÁY
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

  // WIDGET CON: VẼ Ô OTP
  Widget _buildOtpBox(String digit) {
    bool hasValue = digit.isNotEmpty;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface50,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(
          color: hasValue ? AppColors.tertiary500 : AppColors.secondary200,
          width: hasValue ? 1.5 : 1.0,
        ),
      ),
      child: Text(
        digit,
        style: TextStyles.title.copyWith(
          color: AppColors.primary500,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}