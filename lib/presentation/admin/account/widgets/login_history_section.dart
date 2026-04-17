import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class LoginHistorySection extends StatelessWidget {
  const LoginHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final historyData = [
      {
        'device': 'IPhone 14 ProMax',
        'location': 'San Fransico, US',
        'date': 'Oct 15',
      },
      {
        'device': 'IPhone 15 ProMax',
        'location': 'San Fransico, US',
        'date': 'Oct 14',
      },
      {
        'device': 'IPhone 16 ProMax',
        'location': 'San Fransico, US',
        'date': 'Oct 13',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              const Icon(
                Icons.history_outlined,
                color: AppColors.tertiary500,
                size: 24.0,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                'Login History',
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100),
          ),
          child: SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyData.length,
              separatorBuilder: (context, index) => const Divider(
                color: AppColors.secondary100,
                height: AppDimens.spaceLg,
              ),
              itemBuilder: (context, index) {
                final item = historyData[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['device']!,
                            style: TextStyles.bodyLarge.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            item['location']!,
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item['date']!.isNotEmpty)
                      Text(
                        item['date']!,
                        style: TextStyles.label.copyWith(
                          color: AppColors.secondary400,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
