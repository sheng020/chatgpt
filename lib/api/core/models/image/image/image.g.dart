// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenAIImageModel _$OpenAIImageModelFromJson(Map<String, dynamic> json) =>
    OpenAIImageModel(
      created: DateTime.parse(json['created'] as String),
      data: (json['data'] as List<dynamic>)
          .map((e) => OpenAIImageData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OpenAIImageModelToJson(OpenAIImageModel instance) =>
    <String, dynamic>{
      'created': instance.created.toIso8601String(),
      'data': instance.data,
    };
