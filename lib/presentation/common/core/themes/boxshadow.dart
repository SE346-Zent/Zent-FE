import 'package:flutter/material.dart';

class BoxShadowStyles {

  static List<BoxShadow> subtle = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.05),
      blurRadius: 4.0,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> raised = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.10),
      blurRadius: 10.0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> overlay = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.15),
      blurRadius: 24.0,
      offset: const Offset(0, 8),
    ),
  ];
}