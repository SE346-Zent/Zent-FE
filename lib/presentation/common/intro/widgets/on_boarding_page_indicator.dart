import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import '../blocs/on_boarding_cubit.dart';

class OnBoardingPageIndicator extends StatelessWidget {
  final int totalPages;

  const OnBoardingPageIndicator({super.key, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
              width: state.currentPage == index
                  ? AppDimens.spaceLg
                  : AppDimens.spaceSm,
              height: AppDimens.spaceSm,
              decoration: BoxDecoration(
                color: state.currentPage == index
                    ? AppColors.tertiary500
                    : AppColors.background600,
                borderRadius: BorderRadius.circular(AppDimens.boraXs),
              ),
            ),
          ),
        );
      },
    );
  }
}
