import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/chat_viewmodel.dart';
import 'package:zent_fe/presentation/customer/account/widgets/background.dart';
import 'package:zent_fe/presentation/customer/account/widgets/chat_header.dart';
import 'package:zent_fe/presentation/customer/account/widgets/chat_list.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class CustomerChatScreen extends StatelessWidget {
  const CustomerChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ChatViewModel>()..fetchChats(),
      child: const _ChatScreenContent(),
    );
  }
}

class _ChatScreenContent extends StatefulWidget {
  const _ChatScreenContent();

  @override
  State<_ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<_ChatScreenContent>
    with WidgetsBindingObserver {
  void _onSearchPressed() {
    debugPrint("action triggered: tap search button");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh chat list when returning to the app
      context.read<ChatViewModel>().fetchChats(showLoading: false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Silently refresh chat list whenever this screen becomes active
    // (e.g., popping back from detailed chat)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ChatViewModel>().fetchChats(showLoading: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface100,
      body: Stack(
        children: [
          const Background(opacity: 0.1, width: 109.0, height: 129.0),
          SafeArea(
            child: Column(
              children: [
                ChatHeader(onSearchPressed: _onSearchPressed),
                const Expanded(child: ChatList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
