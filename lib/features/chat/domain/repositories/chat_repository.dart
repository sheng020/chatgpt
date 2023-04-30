import 'dart:async';
import 'dart:io';

import 'package:flutter_chatgpt_clone/api/core/models/image/variation/variation.dart';

import '../../../../api/core/models/chat/stream/chat.dart';
import '../../../../api/core/models/image/image/image.dart';

abstract class ChatRepository {
  StreamController<OpenAIStreamChatCompletionModel> chatConversation(
      String prompt);

  Future<OpenAIImageModel> createImageGeneration(String prompt);

  Future<OpenAIImageVariationModel> variation(File image);
}
