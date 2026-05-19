import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/input_field.dart';
import 'select_box_field.dart';
import '../viewmodels/add_new_part_viewmodel.dart';
import 'add_part_info_box.dart';
import 'part_photo_upload.dart';

class AddNewPartForm extends StatelessWidget {
  const AddNewPartForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddNewPartViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AddPartInfoBox(),
        const SizedBox(height: AppDimens.spaceLg),

        InputField(
          label: "Part Name", 
          hintText: "e.g Motherboard",
          controller: viewModel.partNameController,
        ),
        const SizedBox(height: AppDimens.spaceMd),

        SelectBoxField(
          label: "Part Category",
          hintText: "Select Category",
          dropdownItems: const ['Control Board', 'Display Panel', 'Battery', 'Motor', 'Other'],
          selectedValue: viewModel.category,
          onChanged: viewModel.setCategory,
        ),
        const SizedBox(height: AppDimens.spaceMd),

        Row(
          children: [
            Expanded(
              child: InputField(
                label: "MTM", 
                hintText: "e.g 234931043",
                controller: viewModel.mtmController,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: InputField(
                label: "Serial Number", 
                hintText: "e.g 123456",
                controller: viewModel.serialController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceMd),

        InputField(
          label: "Description / Notes",
          hintText: "Describe how it was used or any specific details...",
          maxLines: 4,
          controller: viewModel.descController,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        PartPhotoUpload(
          photos: viewModel.photos,
          onPhotoAdded: viewModel.addPhotoFromPath,
          onPhotoRemoved: viewModel.removePhoto,
        ),
        const SizedBox(height: AppDimens.spaceXl),
      ],
    );
  }
}