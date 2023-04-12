import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_conversation_data_entity.dart';

class ChatConversationData extends ChatConversationDataEntity {
  ChatConversationData({required Message message, required String finishReason, required int index})
      : super(message: message, finishReason: finishReason, index: index);


  factory ChatConversationData.fromJson(Map<String, dynamic> json) {
    return ChatConversationData(
      message: json['message'],
      index: json['index'],
      finishReason: json['finish_reason'],
    );
  }
}
