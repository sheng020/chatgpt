import 'dart:async';
import 'dart:io';

import 'package:flutter_chatgpt_clone/api/core/models/image/variation/variation.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/repositories/chat_repository.dart';

import '../../../../api/core/models/chat/stream/chat.dart';
import '../../../../api/core/models/image/image/image.dart';

class ChatConversationUseCase {
  final ChatRepository repository;

  ChatConversationUseCase({required this.repository});

  StreamController<OpenAIStreamChatCompletionModel> call(String prompt) {
    return repository.chatConversation(prompt);
  }

  Future<OpenAIImageModel> createImageGeneration(String prompt) {
    return repository.createImageGeneration(prompt);
  }

  Future<OpenAIImageVariationModel> variation(File image) {
    return repository.variation(image);
  }
}
