import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar.dart';
import '../view_models/tech_work_order_details_viewmodel.dart';

class DetailsJobInfo extends StatelessWidget {
  final TechWorkOrderDetailsViewModel viewModel;

  const DetailsJobInfo({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 181),
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.jobName,
                style: TextStyles.headline.copyWith(
                  color: AppColors.primary500,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.tertiary500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceXs),
                  Text(
                    viewModel.status,
                    style: TextStyles.label.copyWith(
                      color: AppColors.tertiary500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Avatar(
                  name: viewModel.customerName,
                  showEditIcon: false,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: AppColors.secondary300,
                        ),
                        const SizedBox(width: AppDimens.spaceXs),
                        Text(
                          viewModel.customerName,
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.secondary300,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.secondary300,
                        ),
                        const SizedBox(width: AppDimens.spaceXs),
                        Expanded(
                          child: Text(
                            viewModel.customerAddress,
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary300,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: "Navigate",
                  icon: Icons.near_me_outlined,
                  onPressed: viewModel.onNavigatePressed,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: _buildActionButton(
                  label: "Contact",
                  icon: Icons.phone_outlined,
                  onPressed: viewModel.onContactPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.tertiary50.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          border: Border.all(color: AppColors.tertiary100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.tertiary500),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              label,
              style: TextStyles.middle.copyWith(color: AppColors.tertiary500),
            ),
          ],
        ),
      ),
    );
  }
}
