// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MessageDao? _messageDaoInstance;

  ConversationDao? _conversationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `message` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `messageId` TEXT, `queryPrompt` TEXT, `promptResponse` TEXT, `date` INTEGER NOT NULL, `conversationId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversation` (`conversationId` INTEGER PRIMARY KEY AUTOINCREMENT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MessageDao get messageDao {
    return _messageDaoInstance ??= _$MessageDao(database, changeListener);
  }

  @override
  ConversationDao get conversationDao {
    return _conversationDaoInstance ??=
        _$ConversationDao(database, changeListener);
  }
}

class _$MessageDao extends MessageDao {
  _$MessageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _chatMessageEntityInsertionAdapter = InsertionAdapter(
            database,
            'message',
            (ChatMessageEntity item) => <String, Object?>{
                  'id': item.id,
                  'messageId': item.messageId,
                  'queryPrompt': item.queryPrompt,
                  'promptResponse': item.promptResponse,
                  'date': item.date,
                  'conversationId': item.conversationId
                }),
        _chatMessageEntityUpdateAdapter = UpdateAdapter(
            database,
            'message',
            ['id'],
            (ChatMessageEntity item) => <String, Object?>{
                  'id': item.id,
                  'messageId': item.messageId,
                  'queryPrompt': item.queryPrompt,
                  'promptResponse': item.promptResponse,
                  'date': item.date,
                  'conversationId': item.conversationId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChatMessageEntity> _chatMessageEntityInsertionAdapter;

  final UpdateAdapter<ChatMessageEntity> _chatMessageEntityUpdateAdapter;

  @override
  Future<List<ChatMessageEntity>?> allMessage() async {
    return _queryAdapter.queryList('SELECT * FROM message ORDER BY date',
        mapper: (Map<String, Object?> row) => ChatMessageEntity(
            id: row['id'] as int?,
            messageId: row['messageId'] as String?,
            queryPrompt: row['queryPrompt'] as String?,
            promptResponse: row['promptResponse'] as String?,
            conversationId: row['conversationId'] as int?));
  }

  @override
  Future<int> insertMessage(ChatMessageEntity messageEntity) {
    return _chatMessageEntityInsertionAdapter.insertAndReturnId(
        messageEntity, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateMessage(ChatMessageEntity messageEntity) {
    return _chatMessageEntityUpdateAdapter.updateAndReturnChangedRows(
        messageEntity, OnConflictStrategy.abort);
  }
}

class _$ConversationDao extends ConversationDao {
  _$ConversationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _conversationEntityInsertionAdapter = InsertionAdapter(
            database,
            'conversation',
            (ConversationEntity item) =>
                <String, Object?>{'conversationId': item.conversationId});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ConversationEntity>
      _conversationEntityInsertionAdapter;

  @override
  Future<List<ConversationEntity>?> queryConversations() async {
    return _queryAdapter.queryList('SELECT * FROM conversation',
        mapper: (Map<String, Object?> row) =>
            ConversationEntity(conversationId: row['conversationId'] as int?));
  }

  @override
  Future<int> insertConversation(ConversationEntity conversationEntity) {
    return _conversationEntityInsertionAdapter.insertAndReturnId(
        conversationEntity, OnConflictStrategy.abort);
  }
}
