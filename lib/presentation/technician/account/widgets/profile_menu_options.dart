import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Themes
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Components
import 'profile_menu_item.dart';

// ViewModel
import '../view_models/tech_profile_viewmodel.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          title: 'Personal Info',
          subtitle: 'Contact details & address',
          iconData: Icons.person_outline,
          onTap: () => context.read<TechProfileViewModel>().handleMenuTap(
            context,
            'Personal Info',
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        ProfileMenuItem(
          title: 'Help me',
          subtitle: 'Availability, skills & zones',
          iconData: Icons.person,
          onTap: () => context.read<TechProfileViewModel>().handleMenuTap(
            context,
            'Help me',
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        ProfileMenuItem(
          title: 'Security',
          subtitle: 'Password & 2FA',
          iconData: Icons.lock_outline,
          onTap: () => context.read<TechProfileViewModel>().handleMenuTap(
            context,
            'Security',
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        ProfileMenuItem(
          title: 'Notifications',
          subtitle: 'Alerts & messages',
          iconData: Icons.notifications_none,
          onTap: () => context.read<TechProfileViewModel>().handleMenuTap(
            context,
            'Notifications',
          ),
        ),
      ],
    );
  }
}