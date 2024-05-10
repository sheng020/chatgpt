import 'package:floor/floor.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/conversation_entity.dart';

@dao
abstract class ConversationDao {
  @Query('SELECT * FROM conversation')
  Future<List<ConversationEntity>?> queryConversations();

  @insert
  Future<int> insertConversation(ConversationEntity conversationEntity);

  @Query("DELETE FROM conversation WHERE conversationId = :conversationId")
  Future<int?> deleteConversation(int conversationId);
}
