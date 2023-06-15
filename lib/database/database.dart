import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_chatgpt_clone/database/message_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../features/chat/domain/entities/chat_message_entity.dart';

part 'database.g.dart';

//@TypeConverters([IntListConverter])
@Database(version: 1, entities: [ChatMessageEntity])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;
}

class DatabaseManager {
  static DatabaseManager? _instance;
  late AppDatabase _database;
  late MessageDao _messageDao;

  static DatabaseManager getInstance() {
    _instance ??= DatabaseManager._internal();
    return _instance!;
  }

  DatabaseManager._internal();

  Future<List<ChatMessageEntity>?> queryMessageList() {
    if (kIsWeb) {
      return Future.value(<ChatMessageEntity>[]);
    }
    return _messageDao.allMessage();
  }

  Future<int> insertMessage(ChatMessageEntity messageEntity) {
    if (kIsWeb) return Future.value(0);
    return _messageDao.insertMessage(messageEntity);
  }

  Future<int> updateMessage(ChatMessageEntity messageEntity) {
    if (kIsWeb) return Future.value(0);
    return _messageDao.updateMessage(messageEntity);
  }

  Future<int?> deleteMessage(int id) {
    if (kIsWeb) return Future.value(0);
    return _messageDao.deleteMessage(id);
  }

  Future<AppDatabase?> initialize() async {
    if (kIsWeb) return null;
    _database = await $FloorAppDatabase
        .databaseBuilder('chat_gpt.db')
        /* .addMigrations([migration1to2]) */ .build();
    _messageDao = _database.messageDao;
    return _database;
    //_insertPersonalTask();
  }

  /* final migration1to2 = Migration(1, 2, (database) async {
    await database
        .execute("ALTER TABLE `message` ADD COLUMN `type` INTEGER DEFAULT 0");
  }); */
}
