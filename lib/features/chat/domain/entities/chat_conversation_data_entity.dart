


import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChatConversationDataEntity extends Equatable {

  ChatConversationDataEntity({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  final int index;
  final Message message;
  final String finishReason;

  ChatConversationDataEntity copyWith({
    int? index,
    Message? message,
    String? finishReason,
  }) =>
      ChatConversationDataEntity(
        index: index ?? this.index,
        message: message ?? this.message,
        finishReason: finishReason ?? this.finishReason,
      );

  factory ChatConversationDataEntity.fromRawJson(String str) => ChatConversationDataEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatConversationDataEntity.fromJson(Map<String, dynamic> json) => ChatConversationDataEntity(
    index: json["index"],
    message: Message.fromJson(json["message"]),
    finishReason: json["finish_reason"],
  );

  Map<String, dynamic> toJson() => {
    "index": index,
    "message": message.toJson(),
    "finish_reason": finishReason,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [message,index,finishReason];


}

class Message {
  Message({
    required this.role,
    required this.content,
  });

  final String role;
  final String content;

  Message copyWith({
    String? role,
    String? content,
  }) =>
      Message(
        role: role ?? this.role,
        content: content ?? this.content,
      );

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    role: json["role"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "role": role,
    "content": content,
  };
}