import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import '../viewmodels/tech_work_order_details_viewmodel.dart';

class DetailsArtifactList extends StatelessWidget {
  final TechWorkOrderDetailsViewModel viewModel;

  const DetailsArtifactList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Artifact List",
          style: TextStyles.middle.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.artifacts.length,
          separatorBuilder: (_, index) =>
              const SizedBox(height: AppDimens.spaceSm),
          itemBuilder: (context, index) {
            final artifact = viewModel.artifacts[index];
            return Container(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.surface100,
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
                border: Border.all(color: AppColors.secondary50),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artifact.name,
                          style: TextStyles.title.copyWith(
                            color: AppColors.primary500,
                          ),
                        ),
                        Text(
                          artifact.type,
                          style: TextStyles.label.copyWith(
                            color: AppColors.secondary300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.secondary500,
                    size: 24,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
