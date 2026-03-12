import 'package:flutter/material.dart';
import '../../../common/core/ui/button.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileLogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: 'Sign Out',
      icon: Icons.logout,
      width: 364.0,
      onPressed: onPressed,
    );
  }
}
