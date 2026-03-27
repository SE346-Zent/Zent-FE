import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'profile_input_field.dart';
import '../view_models/complete_work_order_viewmodel.dart';

class DiagnosticSection extends StatelessWidget {
  final CompleteWorkOrderViewModel viewModel;

  const DiagnosticSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
        border: Border.all(color: AppColors.secondary50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Transform.scale(
                scaleX: 1.0,
                scaleY: 1.27,
                child: const Icon(
                  Icons.monitor_heart_outlined,
                  color: AppColors.tertiary500,
                  size: 31,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                "Diagnostic Section",
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          ProfileInputField(
            label: "Diagnostic",
            hintText: "Enter your notes here",
            controller: viewModel.diagnosticNotesController,
            isMultiline: true,
            height: 140,
            labelColor: AppColors.secondary400,
          ),
        ],
      ),
    );
  }
}
