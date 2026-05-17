import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/notifications/viewmodels/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/customer/work/viewmodels/service_viewmodel.dart';
import 'package:zent_fe/presentation/customer/account/widgets/background.dart';
import 'package:zent_fe/presentation/customer/work/widgets/service_action_card.dart';
import 'package:zent_fe/presentation/customer/work/widgets/service_header.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ServiceViewModel>(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => di.sl<NotificationsViewModel>()..fetchUnreadCount(),
          ),
        ],
        child: const _ServiceScreenContent(),
      ),
    );
  }
}

class _ServiceScreenContent extends StatelessWidget {
  const _ServiceScreenContent();

  void _onServiceCardTapped(BuildContext context, String? routeName) {
    if (routeName != null) {
      context.goNamed(routeName);
    } else {
      debugPrint("action triggered: tap on service card with no route");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ServiceViewModel>();

    return Scaffold(
      backgroundColor: AppColors.surface100, // Matching the white background
      body: Stack(
        children: [
          // Background Logo Layer
          const Background(opacity: 0.5, width: 158.0, height: 189.0),

          // Foreground Layer
          SafeArea(
            child: Column(
              children: [
                ServiceHeader(
                  userName: viewModel.userName,
                  avatarUrl: viewModel.avatarUrl,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                    itemCount: viewModel.serviceActions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppDimens.spaceMd),
                    itemBuilder: (context, index) {
                      final action = viewModel.serviceActions[index];
                      return ServiceActionCard(
                        title: action['title'] as String,
                        subtitle: action['subtitle'] as String,
                        iconData: action['icon'] as IconData,
                        onTap: () => _onServiceCardTapped(
                          context,
                          action['routeName'] as String?,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
