


import 'package:flutter_chatgpt_clone/features/chat/domain/repositories/chat_repository.dart';

import '../../../../api/core/models/chat/stream/chat.dart';

class ChatConversationUseCase{
  final ChatRepository repository;

  ChatConversationUseCase({required this.repository});

  Stream<OpenAIStreamChatCompletionModel> call(String prompt){

    return repository.chatConversation(prompt);

  }
}