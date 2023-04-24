import 'dart:async';

import '../../../../api/core/models/chat/stream/chat.dart';

abstract class ChatRepository {
  StreamController<OpenAIStreamChatCompletionModel> chatConversation(
      String prompt);
}
