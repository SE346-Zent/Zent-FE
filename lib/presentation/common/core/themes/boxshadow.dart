import 'package:flutter/material.dart';
import 'colors.dart';

class BoxShadowStyles {
  static BoxShadow subtle = BoxShadow(
    color: const Color(0xFF000000).withValues(alpha: 0.05),
    blurRadius: 4.0,
    offset: const Offset(0, 2),
  );

  static BoxShadow raised = BoxShadow(
    color: const Color(0xFF000000).withValues(alpha: 0.10),
    blurRadius: 10.0,
    offset: const Offset(0, 4),
  );

  static BoxShadow overlay = BoxShadow(
    color: const Color(0xFF000000).withValues(alpha: 0.15),
    blurRadius: 24.0,
    offset: const Offset(0, 8),
  );

  static BoxShadow glowing = BoxShadow(
    color: AppColors.tertiary200.withValues(alpha: 0.5),
    blurRadius: 10.0,
    offset: const Offset(0, 2),
    spreadRadius: 1.0,
  );
}
