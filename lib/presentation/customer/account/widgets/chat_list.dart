import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/routing/rbac_token_store.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/chat_viewmodel.dart';
import 'package:zent_fe/presentation/customer/account/widgets/chat_list_item.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  void _onChatTapped(BuildContext context, ChatPreview chat) {
    if (RbacTokenStore.role == UserRoles.technician) {
      context.pushNamed(
        RouteNames.techDetailedChat,
        pathParameters: {'chatId': chat.id},
        queryParameters: {'name': chat.name},
      );
    } else if (RbacTokenStore.role == UserRoles.admin) {
      context.pushNamed(
        'adminDetailedChat',
        pathParameters: {'chatId': chat.id},
        queryParameters: {'name': chat.name},
      );
    } else {
      context.pushNamed(
        RouteNames.customerDetailedChat,
        pathParameters: {'chatId': chat.id},
        queryParameters: {'name': chat.name},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.tertiary500),
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: AppColors.error50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.error500,
                  size: 48.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Unable to Load Messages",
                style: TextStyles.middle.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                viewModel.errorMessage!,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary300,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              OutlinedButton.icon(
                onPressed: () => viewModel.fetchChats(),
                icon: const Icon(Icons.refresh_rounded, size: 18.0),
                label: const Text("Try Again"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.tertiary500,
                  side: const BorderSide(color: AppColors.tertiary500),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.chats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: AppColors.tertiary50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.forum_outlined,
                  color: AppColors.tertiary500,
                  size: 52.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                "No conversations yet",
                style: TextStyles.middle.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Chat rooms will automatically appear here once a work order has been assigned.",
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.fetchChats(showLoading: false),
      color: AppColors.tertiary500,
      child: ListView.builder(
        itemCount: viewModel.chats.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final chat = viewModel.chats[index];
          return ChatListItem(
            chat: chat,
            onTap: () => _onChatTapped(context, chat),
          );
        },
      ),
    );
  }
}
