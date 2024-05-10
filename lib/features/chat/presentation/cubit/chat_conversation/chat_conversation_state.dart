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
  final Map<int, List<ChatMessageEntity>> chatMessages;
  final int showConversationId;
  final DateTime dateTime = DateTime.now();
  final bool isRequestProcessing;

  ChatConversationLoaded(
      {required this.chatMessages,
      required this.showConversationId,
      required this.isRequestProcessing});
  @override
  List<Object> get props => [chatMessages, showConversationId, dateTime];

  List<ChatMessageEntity>? getShowMessageList() {
    return chatMessages[showConversationId];
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
  final int selectedConversationId;
  final bool isRequestProcessing;

  NotifyTextFieldState(
      {required this.selectedConversationId,
      required this.message,
      required this.isRequestProcessing});

  @override
  List<Object?> get props => [selectedConversationId, message];
}
