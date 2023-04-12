import '../../../../api/core/models/chat/stream/chat.dart';

abstract class ChatRemoteDataSource {
  Stream<OpenAIStreamChatCompletionModel> chatConversation(
    String prompt,
  );
}
