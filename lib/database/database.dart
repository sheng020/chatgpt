
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_chatgpt_clone/database/conversation_dao.dart';
import 'package:flutter_chatgpt_clone/database/message_dao.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/conversation_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../features/chat/domain/entities/chat_message_entity.dart';

part 'database.g.dart';

//@TypeConverters([IntListConverter])
@Database(version: 1, entities: [ChatMessageEntity, ConversationEntity])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;
  ConversationDao get conversationDao;

}

class DatabaseManager {

  static DatabaseManager? _instance;
  late AppDatabase _database;
  late MessageDao _messageDao;
  late ConversationDao _conversationDao;

  static DatabaseManager getInstance() {
    _instance ??= DatabaseManager._internal();
    return _instance!;
  }

  DatabaseManager._internal();

  Future<List<ConversationEntity>?> queryConversationList() {
    return _conversationDao.queryConversations();
  }

  Future<int> insertConversation(ConversationEntity conversationEntity) {
    return _conversationDao.insertConversation(conversationEntity);
  }

  Future<List<ChatMessageEntity>?> queryMessageList() {
    return _messageDao.allMessage();
  }

  Future<int> insertMessage(ChatMessageEntity messageEntity) {
    return _messageDao.insertMessage(messageEntity);
  }

  Future<int> updateMessage(ChatMessageEntity messageEntity) {
    return _messageDao.updateMessage(messageEntity);
  }

  Future<AppDatabase> initialize() async {
    _database = await $FloorAppDatabase
        .databaseBuilder('chat_gpt.db')
        .build();
    _messageDao = _database.messageDao;
    _conversationDao = _database.conversationDao;
    return _database;
    //_insertPersonalTask();
  }

}