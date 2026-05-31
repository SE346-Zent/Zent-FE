import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:provider/provider.dart';
import '../viewmodels/operational_queue_viewmodel.dart';

class OperationalQueueJobCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const OperationalQueueJobCard({super.key, required this.job});

  Future<void> _handleNavigation(BuildContext context, String actionType) async {
    final cleanId = job['id'].toString().replaceAll('#', '');
    final statusEnum = job['statusEnum'].toString();

    if (statusEnum == 'unassigned') {
      await context.pushNamed(
        RouteNames.adminAssignWorkOrder, 
        pathParameters: {'workOrderId': cleanId},
      );
    } else {
      await context.pushNamed(
        RouteNames.adminAssignedWorkOrderDetails, 
        pathParameters: {'workOrderId': cleanId},
      );
    }

    if (context.mounted) {
      context.read<OperationalQueueViewModel>().loadWorkOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String statusEnum = job['statusEnum'].toString();
    final bool isUnassigned = statusEnum == 'unassigned';
    
    final String assigneeName = job['assignee']; 
    
    final Color dotColor = (statusEnum == 'unassigned' || statusEnum == 'pending_acceptance') 
        ? AppColors.warning500 
        : (statusEnum == 'reject_in_review' || statusEnum == 'rejected')
            ? AppColors.error500
            : AppColors.primary500; 

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleNavigation(context, 'card_tap'),
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            boxShadow: [BoxShadowStyles.raised], 
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6.0, color: AppColors.primary500),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['id'],
                          style: TextStyles.middle.copyWith(
                            color: AppColors.secondary500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          job['title'],
                          style: TextStyles.headline.copyWith(
                            color: AppColors.primary500,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceSm),
                        
                        _buildIconTextRow(Icons.person_outline, assigneeName),
                        const SizedBox(height: 4.0),
                        _buildIconTextRow(Icons.location_on_outlined, job['location']),
                        const SizedBox(height: 4.0),
                        _buildIconTextRow(Icons.calendar_today_outlined, job['time']),
                        
                        const SizedBox(height: AppDimens.spaceMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  job['status'],
                                  style: TextStyles.title.copyWith(
                                    color: AppColors.primary500,
                                  ),
                                ),
                              ],
                            ),
                            
                            if (statusEnum == 'unassigned' || statusEnum == 'pending_acceptance')
                              ElevatedButton(
                                onPressed: () => _handleNavigation(context, 'button_tap'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary500, 
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                  minimumSize: const Size(0, 36),
                                ),
                                child: Text(
                                  isUnassigned ? 'Assign' : 'Detail',
                                  style: TextStyles.middle.copyWith(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary400),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary500),
          ),
        ),
      ],
    );
  }
}