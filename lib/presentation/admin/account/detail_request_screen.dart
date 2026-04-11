import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'widgets/admin_text_field.dart';
import 'viewmodel/detail_request_viewmodel.dart';

class DetailRequestScreen extends StatelessWidget {
  const DetailRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<DetailRequestViewModel>(),
      child: const _DetailRequestScreenContent(),
    );
  }
}

class _DetailRequestScreenContent extends StatelessWidget {
  const _DetailRequestScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailRequestViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              'Detail Request',
              style: TextStyles.headline.copyWith(color: AppColors.primary500),
            ),
            Text(
              '#WO-12345 • 12h30 AM',
              style: TextStyles.label.copyWith(color: AppColors.secondary500),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.tertiary50,
                borderRadius: BorderRadius.circular(AppDimens.boraMd),
                border: Border.all(color: AppColors.tertiary500, width: 1.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.tertiary500,
                    size: 24,
                  ),
                  const SizedBox(width: AppDimens.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review part details for inventory update',
                          style: TextStyles.bodyLarge.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Enter the details of the part that was not found in the inventory system.',
                          style: TextStyles.label.copyWith(
                            color: AppColors.secondary300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            AdminTextField(
              label: 'Part Name',
              hint: '',
              controller: viewModel.partNameController,
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              'Part Category',
              style: TextStyles.title.copyWith(color: AppColors.primary500),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface100,
                borderRadius: BorderRadius.circular(AppDimens.boraMd),
                border: Border.all(color: AppColors.secondary100, width: 1.0),
                boxShadow: [BoxShadowStyles.subtle],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: viewModel.selectedCategory,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.secondary400,
                  ),
                  items: viewModel.categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: viewModel.setCategory,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Row(
              children: [
                Expanded(
                  child: AdminTextField(
                    label: 'MTM',
                    hint: '',
                    controller: viewModel.mtmController,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: AdminTextField(
                    label: 'Serial Number',
                    hint: '',
                    controller: viewModel.serialNumberController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMd),
            AdminTextField(
              label: 'Description / Notes',
              hint: '',
              controller: viewModel.descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Part Photo',
                  style: TextStyles.title.copyWith(color: AppColors.primary500),
                ),
                Text(
                  'MAX: 5 PHOTOS',
                  style: TextStyles.label.copyWith(
                    color: AppColors.tertiary500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceSm),
            SizedBox(
              height: 80.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.photoUrls.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimens.spaceSm),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    child: Image.asset(
                      viewModel.photoUrls[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        color: AppColors.background500,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.tertiary50,
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                  boxShadow: [BoxShadowStyles.subtle],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Reject',
                    style: TextStyles.title.copyWith(
                      color: AppColors.tertiary500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              flex: 2,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.tertiary500,
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                  boxShadow: [BoxShadowStyles.glowing],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Approve Request',
                    style: TextStyles.title.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
