import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

// Re-using common widgets
import 'package:zent_fe/presentation/common/auth/login/widgets/success_checkmark.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/zent_bottom_logo.dart';
import 'viewmodels/request_service_viewmodel.dart';

class RequestServiceSuccessScreen extends StatelessWidget {
  const RequestServiceSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestServiceViewModel>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Indicator
                    Text(
                      'Step 5 of 5',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.tertiary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Text(
                      'Submit Successfully',
                      style: TextStyles.display.copyWith(
                        color: AppColors.primary500,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Center(child: SuccessCheckmark()),
                    const SizedBox(height: AppDimens.spaceXl),
                    Center(
                      child: Text(
                        'Email Sent!',
                        textAlign: TextAlign.center,
                        style: TextStyles.headline.copyWith(
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.secondary500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'The information was sent to ',
                            ),
                            TextSpan(
                              text: viewModel.email ?? 'example@gmail.com',
                              style: TextStyles.bodyLarge.copyWith(
                                color: AppColors.tertiary500,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  '. Please usually check your email for any new updates.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.tertiary500,
                        borderRadius: BorderRadius.circular(AppDimens.boraMd),
                        boxShadow: [BoxShadowStyles.raised],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(RouteNames.customerServices);
                          viewModel.reset();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraMd,
                            ),
                          ),
                        ),
                        child: Text(
                          'Go to Services',
                          style: TextStyles.title.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimens.spaceLg,
                        ),
                        child: ZentBottomLogo(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
