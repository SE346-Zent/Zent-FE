import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/menu_item.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDimens.spaceSm),
        MenuItem(
          title: 'Security Settings',
          subtitle: 'Security & Biomaker',
          iconData: Icons.lock_outline,
          onTap: () => context.read<ProfileViewModel>().handleMenuTap(
            context,
            'Security Settings',
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        MenuItem(
          title: 'Available Roles',
          subtitle: 'Configure the detailed roles of users',
          iconData: Icons.domain_outlined,
          onTap: () => context.read<ProfileViewModel>().handleMenuTap(
            context,
            'Available Roles',
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        MenuItem(
          title: 'Inventory Assets',
          subtitle: 'Manage product and part in the warehouse',
          iconData: Icons.inventory_2_outlined,
          onTap: () => context.read<ProfileViewModel>().handleMenuTap(
            context,
            'Inventory Assets',
          ),
        ),
      ],
    );
  }
}
