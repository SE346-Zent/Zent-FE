import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'blocs/chat_bloc.dart';
import 'blocs/chat_event.dart';
import 'blocs/chat_state.dart';
import 'widgets/chat_list_item.dart';

class CustomerMessagesScreen extends StatelessWidget {
  const CustomerMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(ChatDataFetchRequested()),
      child: const _MessagesScreenContent(),
    );
  }
}

class _MessagesScreenContent extends StatelessWidget {
  const _MessagesScreenContent();

  void _onSearchPressed() {
    debugPrint("action triggered: tap search button");
  }

  void _onChatTapped(ChatPreview chat) {
    debugPrint("action triggered: tap chat with ${chat.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface100,
      body: Stack(
        children: [
          // Background Logo Layer
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/ZentLogo.webp',
                width: 109.0,
                height: 129.0,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          
          // Foreground Layer
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMd,
                    vertical: AppDimens.spaceMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Messages',
                        style: TextStyles.headline.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      InkWell(
                        onTap: _onSearchPressed,
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                        child: Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            color: AppColors.tertiary50,
                            borderRadius: BorderRadius.circular(AppDimens.boraSm),
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 14.0,
                            height: 14.0,
                            child: Icon(
                              Icons.search,
                              size: 14.0,
                              color: AppColors.tertiary500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Chat List
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatLoadSuccess) {
                        final chats = state.chats;
                        return ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return ChatListItem(
                              chat: chat,
                              onTap: () => _onChatTapped(chat),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
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
