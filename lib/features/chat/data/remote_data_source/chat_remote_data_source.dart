import 'dart:async';

import '../../../../api/core/models/chat/stream/chat.dart';

abstract class ChatRemoteDataSource {
  StreamController<OpenAIStreamChatCompletionModel> chatConversation(
    String prompt,
  );
}
