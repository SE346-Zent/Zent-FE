import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/admin/work/viewmodels/operational_queue_viewmodel.dart';

class FilterDialog extends StatelessWidget {
  final OperationalQueueViewModel viewModel;

  const FilterDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      alignment: Alignment.topLeft,
      insetPadding: const EdgeInsets.only(top: 170.0, left: 16.0),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(AppDimens.spaceSm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          boxShadow: [BoxShadowStyles.overlay],
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtering',
                  style: TextStyles.middle.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
                const Divider(
                  color: AppColors.secondary50,
                  thickness: 1.0,
                  height: 16,
                ),
                const SizedBox(height: AppDimens.spaceSm),
                _buildSortRow(
                  'Appointment',
                  viewModel.appointmentSort,
                  ['None', 'Earliest first', 'Latest first'],
                  (val) {
                    if (val != null) {
                      viewModel.updateAppointmentSort(val);
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: AppDimens.spaceMd),
                ElevatedButton(
                  onPressed: () {
                    viewModel.resetSort();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiary500,
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceLg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyles.bodyLarge.copyWith(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSortRow(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
        PopupMenuButton<String>(
          initialValue: value,
          onSelected: onChanged,
          offset: const Offset(0, 40),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              border: Border.all(color: AppColors.secondary200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
                const SizedBox(width: 4.0),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.secondary500,
                ),
              ],
            ),
          ),
          itemBuilder: (BuildContext context) {
            return options.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyles.bodyMedium.copyWith(
                    color: choice == value
                        ? AppColors.primary500
                        : AppColors.secondary500,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
