import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/admin/account/widgets/save_changes_button.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/personal_info_viewmodel.dart';

class PersonalInfoSaveButton extends StatelessWidget {
  const PersonalInfoSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: SaveChangesButton(
        onPressed: () {
          context.read<PersonalInfoViewModel>().saveChanges(context);
          debugPrint("action triggered: save personal info changes");
        },
      ),
    );
  }
}
