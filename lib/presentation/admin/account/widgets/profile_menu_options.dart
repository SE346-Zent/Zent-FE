import 'package:flutter/material.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/ui/profile_menu_item.dart';
import 'package:provider/provider.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          title: 'User Management',
          subtitle: 'Contact details & address',
          iconData: Icons.person_outline,
          onTap: () => context.read<ProfileViewModel>().handleMenuTap(
            context,
            'User Management',
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        ProfileMenuItem(
          title: 'Security Settings',
          subtitle: 'Security & Biomaker',
          iconData: Icons.lock_outline,
          onTap: () => context.read<ProfileViewModel>().handleMenuTap(
            context,
            'Security Settings',
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        ProfileMenuItem(
          title: 'System Log',
          subtitle: 'Security & Biomaker',
          iconData: Icons.person_outline,
          onTap: () => context.read<ProfileViewModel>().handleMenuTap(
            context,
            'System Log',
          ),
        ),
      ],
    );
  }
}
