import 'dart:async';
import 'dart:io';

import 'package:flutter_chatgpt_clone/api/core/models/image/enum.dart';
import 'package:flutter_chatgpt_clone/api/core/models/image/image/image.dart';
import 'package:flutter_chatgpt_clone/api/core/models/image/variation/variation.dart';
import 'package:flutter_chatgpt_clone/features/chat/data/remote_data_source/chat_remote_data_source.dart';
import 'package:http/http.dart' as http;

import '../../../../api/core/models/chat/stream/chat.dart';
import '../../../../api/core/models/chat/sub_models/choices/sub_models/message.dart';
import '../../../../api/instance/openai.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client httpClient;

  ChatRemoteDataSourceImpl({required this.httpClient});

  @override
  StreamController<OpenAIStreamChatCompletionModel> chatConversation(
      String prompt) {
    final queryPrompt = prompt;

    // Creates A Stream Of Chat Completions.
    final chatStream = OpenAI.instance.chat.createStream(
      model: OpenAI.chatModel.name,
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: queryPrompt,
          role: "user",
        )
      ],
    );

    return chatStream;
  }

  @override
  Future<OpenAIImageModel> createImageGeneration(String prompt) {
    return OpenAI.instance.image
        .create(prompt: prompt, n: 4, size: OpenAIImageSize.size512);
  }

  Future<OpenAIImageVariationModel> variation(File image) {
    return OpenAI.instance.image
        .variation(image: image, n: 4, size: OpenAIImageSize.size512);
  }
}
