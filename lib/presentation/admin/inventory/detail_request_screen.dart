import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/admin/account/viewmodels/detail_request_viewmodel.dart';
import 'package:zent_fe/presentation/admin/account/widgets/admin_text_field.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

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

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason for Rejection',
                  style: TextStyles.middle.copyWith(color: Colors.black),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.background500,
                    hintText:
                        'Add detailed reason why this request should be rejected',
                    hintStyle: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      borderSide: const BorderSide(
                        color: AppColors.secondary300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      borderSide: const BorderSide(color: AppColors.primary500),
                    ),
                    contentPadding: const EdgeInsets.all(AppDimens.spaceMd),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadowStyles.glowing],
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error500,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
                    ),
                    child: Text(
                      'Reject',
                      style: TextStyles.title.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailRequestViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      resizeToAvoidBottomInset: false,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary50,
                      borderRadius: BorderRadius.circular(AppDimens.boraMd),
                      border: Border.all(
                        color: AppColors.tertiary500,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.tertiary500,
                          size: 32,
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
                    readOnly: true,
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  Text(
                    'Part Category',
                    style: TextStyles.title.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary50,
                      borderRadius: BorderRadius.circular(AppDimens.boraMd),
                      border: Border.all(
                        color: AppColors.secondary100,
                        width: 1.0,
                      ),
                      boxShadow: [BoxShadowStyles.subtle],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: viewModel.selectedCategory,
                        isExpanded: true,
                        icon: const SizedBox.shrink(),
                        items: viewModel.categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyles.bodyLarge.copyWith(
                                color: AppColors.secondary200,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: null,
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
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Expanded(
                        child: AdminTextField(
                          label: 'Serial Number',
                          hint: '',
                          controller: viewModel.serialNumberController,
                          readOnly: true,
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
                    readOnly: true,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Part Photo',
                        style: TextStyles.title.copyWith(
                          color: AppColors.primary500,
                        ),
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
                ],
              ),
            ),
          ),
          Container(
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
                      onPressed: () => _showRejectDialog(context),
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
                        'Approve',
                        style: TextStyles.title.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
