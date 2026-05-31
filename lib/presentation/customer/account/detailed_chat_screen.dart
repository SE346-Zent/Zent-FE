import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final String? partnerName;
  const DetailedChatScreen({super.key, required this.chatId, this.partnerName});

  @override
  State<DetailedChatScreen> createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen>
    with WidgetsBindingObserver {
  late DetailedChatViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = sl<DetailedChatViewModel>();
    _viewModel.init(widget.chatId, initialPartnerName: widget.partnerName);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100) {
      _viewModel.loadMoreMessages();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // According to guide: Send LEAVING when the app goes to background, and VIEWING on resume
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _viewModel.chatService.stopViewing(widget.chatId);
    } else if (state == AppLifecycleState.resumed) {
      _viewModel.chatService.startViewing(widget.chatId);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: _DetailedChatView(scrollController: _scrollController),
    );
  }
}

class _DetailedChatView extends StatelessWidget {
  final ScrollController scrollController;
  const _DetailedChatView({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailedChatViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface100,
        appBar: _buildCustomHeader(context, viewModel.chatPartnerName),
        body: SafeArea(
          child: Column(
            children: [
              // Vùng hiển thị tin nhắn hoặc loading
              Expanded(
                child: viewModel.isLoading && viewModel.messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.all(AppDimens.spaceMd),
                        itemCount:
                            viewModel.messages.length +
                            (viewModel.isLoadMoreLoading ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 2.0),
                        itemBuilder: (context, index) {
                          if (viewModel.isLoadMoreLoading && index == 0) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.secondary500,
                                  ),
                                ),
                              ),
                            );
                          }
                          final msgIndex = viewModel.isLoadMoreLoading
                              ? index - 1
                              : index;
                          final msg = viewModel.messages[msgIndex];

                          // Messenger-style time separator calculation
                          bool showSeparator = false;
                          if (msgIndex == 0) {
                            showSeparator = true;
                          } else {
                            final prevMsg = viewModel.messages[msgIndex - 1];
                            final gap = msg.dateTime.difference(
                              prevMsg.dateTime,
                            );
                            if (gap.inMinutes.abs() >= 10) {
                              showSeparator = true;
                            }
                          }

                          final bubble = _buildMessageBubble(
                            context,
                            viewModel,
                            msg,
                          );
                          if (showSeparator) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTimeSeparator(msg.dateTime),
                                bubble,
                              ],
                            );
                          }
                          return bubble;
                        },
                      ),
              ),

              // Thanh nhập tin nhắn
              _buildBottomInputArea(context, viewModel),

              // Nâng thanh chat lên cao một chút
              const SizedBox(height: AppDimens.spaceMd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSeparator(DateTime dateTime) {
    final now = DateTime.now();
    final localDt = dateTime.toLocal();
    final localNow = now.toLocal();
    final diff = localNow.difference(localDt);

    final isToday =
        localDt.year == localNow.year &&
        localDt.month == localNow.month &&
        localDt.day == localNow.day;

    final yesterday = localNow.subtract(const Duration(days: 1));
    final isYesterday =
        localDt.year == yesterday.year &&
        localDt.month == yesterday.month &&
        localDt.day == yesterday.day;

    String label;
    if (isToday) {
      label = DateFormat('HH:mm').format(localDt);
    } else if (isYesterday) {
      label = 'Yesterday, ${DateFormat('HH:mm').format(localDt)}';
    } else if (diff.inDays < 7) {
      label =
          '${DateFormat('EEEE').format(localDt)}, ${DateFormat('HH:mm').format(localDt)}';
    } else {
      label = DateFormat('MMM dd, HH:mm').format(localDt);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary400,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomHeader(BuildContext context, String name) {
    return AppBar(
      backgroundColor: AppColors.tertiary400,
      elevation: 4.0,
      shadowColor: const Color(0xFF000000).withValues(alpha: 0.1),
      shape: const Border(), // sharp/squared
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(AppAssets.onboarding1),
            backgroundColor: AppColors.secondary200,
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: Text(
              name.isEmpty ? "Chat Partner" : name,
              style: TextStyles.headline.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    DetailedChatViewModel viewModel,
    ChatMessage message,
  ) {
    final hasImageOnly =
        message.imageUrl != null &&
        message.imageUrl!.isNotEmpty &&
        message.text.isEmpty;

    final bubbleBgColor = hasImageOnly
        ? Colors.transparent
        : (message.isMe ? AppColors.tertiary400 : AppColors.surface600);

    final bubblePadding = hasImageOnly
        ? EdgeInsets.zero
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 4);

    final bubbleBoxShadow = hasImageOnly
        ? <BoxShadow>[]
        : [BoxShadowStyles.subtle];

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
            padding: bubblePadding,
            decoration: BoxDecoration(
              color: bubbleBgColor,
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
              boxShadow: bubbleBoxShadow,
            ),
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.imageUrl != null &&
                    message.imageUrl!.isNotEmpty) ...[
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.55,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.boraMd),
                      child: Image.network(
                        viewModel.chatService.getAttachmentUrl(
                          message.imageUrl!,
                        ),
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Container(
                                width: 150,
                                height: 150,
                                color: AppColors.secondary50,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.secondary400,
                                        ),
                                  ),
                                ),
                              );
                            },
                        errorBuilder: (context, error, stackTrace) => Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.red.shade100,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Failed to load image"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (message.text.isNotEmpty) const SizedBox(height: 8),
                ],
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: TextStyles.bodyLarge.copyWith(
                      color: message.isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                if (message.time.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: message.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(
                          fontSize: 10,
                          color: hasImageOnly
                              ? AppColors.secondary400
                              : (message.isMe
                                    ? Colors.white70
                                    : Colors.black54),
                        ),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isSeen ? Icons.done_all : Icons.done,
                          size: 14,
                          color: hasImageOnly
                              ? AppColors.secondary300
                              : (message.isSeen
                                    ? AppColors.secondary300
                                    : Colors.white70),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
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

  Widget _buildBottomInputArea(
    BuildContext context,
    DetailedChatViewModel viewModel,
  ) {
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Photo Gallery'),
                          onTap: () {
                            Navigator.pop(ctx);
                            viewModel.sendImage();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                          onTap: () {
                            Navigator.pop(ctx);
                            viewModel.sendCameraImage();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
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
              icon: viewModel.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondary500,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.send_outlined,
                      color: AppColors.secondary500,
                    ),
              onPressed: viewModel.isLoading ? null : viewModel.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
