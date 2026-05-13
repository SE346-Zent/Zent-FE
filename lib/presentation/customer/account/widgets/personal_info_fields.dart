import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/input_field.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/personal_info_viewmodel.dart';

class PersonalInfoFields extends StatelessWidget {
  const PersonalInfoFields({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PersonalInfoViewModel>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: InputField(
            label: 'Full Name',
            initialValue: viewModel.fullName,
            leadingIcon: Icons.person_outline,
            onChanged: (val) =>
                context.read<PersonalInfoViewModel>().updateFullName(val),
          ),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: InputField(
            label: 'Email Address',
            initialValue: viewModel.emailAddress,
            leadingIcon: Icons.mail_outline,
            onChanged: (val) =>
                context.read<PersonalInfoViewModel>().updateEmail(val),
          ),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: InputField(
            label: 'Phone Number',
            initialValue: viewModel.phoneNumber,
            leadingIcon: Icons.phone_outlined,
            onChanged: (val) =>
                context.read<PersonalInfoViewModel>().updatePhone(val),
          ),
        ),
      ],
    );
  }
}
