part of 'chat_conversation_cubit.dart';

abstract class ChatConversationState extends Equatable {
  const ChatConversationState();
}

class ChatConversationInitial extends ChatConversationState {
  @override
  List<Object> get props => [];
}

class ChatConversationLoading extends ChatConversationState {
  @override
  List<Object> get props => [];
}

class ChatConversationLoaded extends ChatConversationState {
  final List<ChatMessageEntity> chatMessages;
  final DateTime dateTime = DateTime.now();
  final bool isRequestProcessing;

  ChatConversationLoaded(
      {required this.chatMessages, required this.isRequestProcessing});
  @override
  List<Object> get props => [chatMessages, dateTime];

  List<ChatMessageEntity>? getShowMessageList() {
    return chatMessages;
  }
}

class ConversationUser extends ChatConversationState {
  final String userName;

  ConversationUser({required this.userName});

  @override
  List<Object?> get props => [userName];
}

class FloatingActionState extends ChatConversationState {
  final bool showFloatingActionButton;

  FloatingActionState({required this.showFloatingActionButton});

  @override
  List<Object?> get props => [showFloatingActionButton];
}

class NotifyTextFieldState extends ChatConversationState {
  final String message;
  final bool isRequestProcessing;
  String? translation;

  NotifyTextFieldState(
      {required this.message,
      required this.isRequestProcessing,
      this.translation});

  @override
  List<Object?> get props => [message, isRequestProcessing, translation];
}

class ConversationLeftCount extends ChatConversationState {
  final int leftCount;
  ConversationLeftCount({required this.leftCount});

  @override
  List<Object?> get props => [leftCount];
}
