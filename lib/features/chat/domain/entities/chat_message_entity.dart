

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'message')
class ChatMessageEntity extends Equatable {

  @PrimaryKey(autoGenerate: true)
  int? id;
  final String? messageId;
  final String? queryPrompt;
  final String? promptResponse;
  final int date = DateTime.now().millisecondsSinceEpoch;
  final int? conversationId;

  ChatMessageEntity({this.id, this.messageId, this.queryPrompt, this.promptResponse, this.conversationId});

  @override
  List<Object?> get props => [this.id, messageId, queryPrompt, promptResponse, conversationId, date];

}