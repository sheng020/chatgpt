import 'package:floor/floor.dart';

import '../features/chat/domain/entities/chat_message_entity.dart';

@dao
abstract class MessageDao {
  @Query('SELECT * FROM message ORDER BY date')
  Future<List<ChatMessageEntity>?> allMessage();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertMessage(ChatMessageEntity messageEntity);

  @update
  Future<int> updateMessage(ChatMessageEntity messageEntity);

  @Query("DELETE FROM message WHERE id = :id")
  Future<int?> deleteMessage(int id);
}
