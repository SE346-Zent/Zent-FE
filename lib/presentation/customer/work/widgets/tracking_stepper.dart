import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class TrackingStepper extends StatelessWidget {
  final int currentStep;

  const TrackingStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepItem(
          Icons.assignment_outlined,
          'Ticket Open',
          1,
          currentStep,
        ),
        _buildStepLine(2, currentStep),
        _buildStepItem(
          Icons.person_add_alt_1_outlined,
          'Tech Assigned',
          2,
          currentStep,
        ),
        _buildStepLine(3, currentStep),
        _buildStepItem(
          Icons.build_circle_outlined,
          'In Progress',
          3,
          currentStep,
        ),
        _buildStepLine(4, currentStep),
        _buildStepItem(Icons.check_circle_outline, 'Done', 4, currentStep),
      ],
    );
  }

  Widget _buildStepItem(
    IconData icon,
    String label,
    int stepIndex,
    int currentStep,
  ) {
    final isActive = stepIndex <= currentStep;
    final color = isActive ? AppColors.tertiary500 : AppColors.secondary300;

    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : AppColors.secondary100,
            ),
            child: Icon(icon, size: 20, color: isActive ? Colors.white : color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyles.label.copyWith(
              color: isActive ? AppColors.tertiary500 : AppColors.secondary400,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int stepIndex, int currentStep) {
    final isActive = stepIndex <= currentStep;
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(top: 18),
        height: 2,
        color: isActive ? AppColors.tertiary500 : AppColors.secondary200,
      ),
    );
  }
}
