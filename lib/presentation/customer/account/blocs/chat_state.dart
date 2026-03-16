import 'package:equatable/equatable.dart';

class ChatPreview extends Equatable {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? avatarUrl;

  const ChatPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, lastMessage, time, unreadCount, avatarUrl];
}

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final List<ChatPreview> chats;

  const ChatLoadSuccess(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatLoadFailure extends ChatState {
  final String errorMessage;

  const ChatLoadFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
