import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/customer/account/blocs/chat_bloc.dart';
import 'package:zent_fe/presentation/customer/account/blocs/chat_event.dart';
import 'package:zent_fe/presentation/customer/account/widgets/background.dart';
import 'package:zent_fe/presentation/customer/account/widgets/chat_header.dart';
import 'package:zent_fe/presentation/customer/account/widgets/chat_list.dart';

class CustomerChatScreen extends StatelessWidget {
  const CustomerChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(ChatDataFetchRequested()),
      child: const _ChatScreenContent(),
    );
  }
}

class _ChatScreenContent extends StatelessWidget {
  const _ChatScreenContent();

  void _onSearchPressed() {
    debugPrint("action triggered: tap search button");
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
