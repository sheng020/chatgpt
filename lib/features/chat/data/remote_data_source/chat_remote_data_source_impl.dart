import 'dart:async';

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
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: queryPrompt,
          role: "user",
        )
      ],
    );

    return chatStream;
  }
}
