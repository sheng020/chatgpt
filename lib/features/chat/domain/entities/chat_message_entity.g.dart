// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageEntity _$ChatMessageEntityFromJson(Map<String, dynamic> json) =>
    ChatMessageEntity(
      id: json['id'] as int?,
      messageId: json['messageId'] as String?,
      queryPrompt: json['queryPrompt'] as String?,
      promptResponse: json['promptResponse'] as String?,
      conversationId: json['conversationId'] as int?,
      date: json['date'] as int?,
      type: json['type'] as int,
    );

Map<String, dynamic> _$ChatMessageEntityToJson(ChatMessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messageId': instance.messageId,
      'queryPrompt': instance.queryPrompt,
      'promptResponse': instance.promptResponse,
      'date': instance.date,
      'conversationId': instance.conversationId,
      'type': instance.type,
    };
