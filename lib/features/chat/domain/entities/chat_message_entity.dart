import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_entity.g.dart';

const TYPE_CHAT = 0;
const TYPE_IMAGE_GENERATION = 1;
const TYPE_IMAGE_VARIATION = 2;
const TYPE_REAL_TIME_TRANSLATE = 3;

@JsonSerializable()
@Entity(tableName: 'message')
class ChatMessageEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String? messageId;
  final String? queryPrompt;
  final String? promptResponse;
  final int? date;
  final int type;

  ChatMessageEntity(
      {this.id,
      this.messageId,
      this.queryPrompt,
      this.promptResponse,
      this.date,
      required this.type});

  @override
  List<Object?> get props =>
      [this.id, messageId, queryPrompt, promptResponse, date];

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageEntityToJson(this);
}
