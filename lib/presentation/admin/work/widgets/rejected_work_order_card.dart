import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/domain/entities/reject_form.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';

class RejectedWorkOrderCard extends StatefulWidget {
  final RejectForm rejectForm;
  final Future<void> Function() onApprove;
  final Future<void> Function() onDeny;
  final VoidCallback onDetailTap;

  const RejectedWorkOrderCard({
    super.key,
    required this.rejectForm,
    required this.onApprove,
    required this.onDeny,
    required this.onDetailTap,
  });

  @override
  State<RejectedWorkOrderCard> createState() => _RejectedWorkOrderCardState();
}

class _RejectedWorkOrderCardState extends State<RejectedWorkOrderCard> {
  bool _isApproving = false;
  bool _isDenying = false;

  @override
  Widget build(BuildContext context) {
    final form = widget.rejectForm;
    final onApprove = widget.onApprove;
    final onDeny = widget.onDeny;
    final onDetailTap = widget.onDetailTap;
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.overlay],
      ),
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            form.workOrderNumber.startsWith('WO')
                ? form.workOrderNumber
                : '#${form.workOrderNumber}',
            style: TextStyles.middle.copyWith(color: AppColors.tertiary500),
          ),
          const SizedBox(height: 4.0),
          Text(
            form.reason,
            style: TextStyles.headline.copyWith(color: AppColors.primary500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          ThrottledGestureDetector(
            onTap: onDetailTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary50,
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'TECHNICIAN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserAvatar(
                                  size: 20,
                                  name: form.technicianName.isNotEmpty
                                      ? form.technicianName
                                      : 'Technician',
                                  avatarUrl: null,
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    form.technicianName.isNotEmpty
                                        ? form.technicianName
                                        : 'N/A',
                                    style: TextStyles.middle.copyWith(
                                      color: Colors.black,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'CUSTOMER',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserAvatar(
                                  size: 20,
                                  name: form.customerName.isNotEmpty
                                      ? form.customerName
                                      : 'Customer',
                                  avatarUrl: null,
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    form.customerName.isNotEmpty
                                        ? form.customerName
                                        : 'N/A',
                                    style: TextStyles.middle.copyWith(
                                      color: Colors.black,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Divider(color: AppColors.secondary100, height: 1.0),
                  const SizedBox(height: 10.0),
                  const Text(
                    'TECHNICIAN NOTES',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    '"${form.reason}"',
                    style: TextStyles.bodyLarge.copyWith(color: Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              Expanded(
                child: ThrottledGestureDetector(
                  onTap: _isApproving || _isDenying
                      ? null
                      : () async {
                          setState(() {
                            _isDenying = true;
                          });
                          try {
                            await onDeny();
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isDenying = false;
                              });
                            }
                          }
                        },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary500,
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      border: Border.all(
                        color: AppColors.tertiary500,
                        width: 1.5,
                      ),
                      boxShadow: [BoxShadowStyles.glowing],
                    ),
                    alignment: Alignment.center,
                    child: _isDenying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Deny',
                            style: TextStyles.middle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: ThrottledGestureDetector(
                  onTap: _isApproving || _isDenying
                      ? null
                      : () async {
                          setState(() {
                            _isApproving = true;
                          });
                          try {
                            await onApprove();
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isApproving = false;
                              });
                            }
                          }
                        },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface600,
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      border: Border.all(
                        color: AppColors.surface600,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _isApproving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.primary500,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Approve',
                            style: TextStyles.middle.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
