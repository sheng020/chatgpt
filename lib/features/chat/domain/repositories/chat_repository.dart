import '../../../../api/core/models/chat/stream/chat.dart';

abstract class ChatRepository {
  Stream<OpenAIStreamChatCompletionModel> chatConversation(String prompt);
}
