import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
import 'package:go_router/go_router.dart';
import 'viewmodels/detailed_chat_viewmodel.dart';

class DetailedChatScreen extends StatefulWidget {
  final String chatId;
  const DetailedChatScreen({super.key, required this.chatId});

  @override
  State<DetailedChatScreen> createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  late DetailedChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<DetailedChatViewModel>();
    _viewModel.init(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _DetailedChatView(),
    );
  }
}

class _DetailedChatView extends StatelessWidget {
  const _DetailedChatView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailedChatViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface100,
        body: SafeArea(
          child: Column(
            children: [
              _buildCustomHeader(context, viewModel.chatPartnerName),

              // Vùng hiển thị tin nhắn
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  itemCount: viewModel.messages.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimens.spaceMd),
                  itemBuilder: (context, index) {
                    final msg = viewModel.messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),

              // Thanh nhập tin nhắn
              _buildBottomInputArea(viewModel),

              // Nâng thanh chat lên cao một chút
              const SizedBox(height: AppDimens.spaceMd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tertiary500,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.boraMd),
          bottomRight: Radius.circular(AppDimens.boraMd),
        ),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(
              AppAssets.onboarding1,
            ), // Fallback avatar
            backgroundColor: AppColors.secondary200,
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: Text(
              name,
              style: TextStyles.headline.copyWith(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Row(
      mainAxisAlignment: message.isMe
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!message.isMe) ...[
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(AppAssets.onboarding1),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              // Mình: tertiary400, Đối tác: surface600
              color: message.isMe
                  ? AppColors.tertiary400
                  : AppColors.surface600,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppDimens.boraMd),
                topRight: const Radius.circular(AppDimens.boraMd),
                bottomLeft: Radius.circular(
                  message.isMe ? AppDimens.boraMd : 0,
                ),
                bottomRight: Radius.circular(
                  message.isMe ? 0 : AppDimens.boraMd,
                ),
              ),
              boxShadow: [BoxShadowStyles.subtle],
            ),
            child: Text(
              message.text,
              style: TextStyles.bodyLarge.copyWith(
                color: message.isMe ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
        if (message.isMe) ...[
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(AppAssets.onboarding1),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomInputArea(DetailedChatViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.tertiary50,
          borderRadius: BorderRadius.circular(AppDimens.boraLg),
          border: Border.all(color: AppColors.secondary300),
          boxShadow: [BoxShadowStyles.raised],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.secondary500,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: viewModel.messageController,
                decoration: InputDecoration(
                  hintText: 'Type here to chat',
                  hintStyle: TextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send_outlined,
                color: AppColors.secondary500,
              ),
              onPressed: viewModel.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
