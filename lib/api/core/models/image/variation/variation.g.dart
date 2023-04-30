// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenAIImageVariationModel _$OpenAIImageVariationModelFromJson(
        Map<String, dynamic> json) =>
    OpenAIImageVariationModel(
      created: DateTime.parse(json['created'] as String),
      data: (json['data'] as List<dynamic>)
          .map((e) => OpenAIVariationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OpenAIImageVariationModelToJson(
        OpenAIImageVariationModel instance) =>
    <String, dynamic>{
      'created': instance.created.toIso8601String(),
      'data': instance.data,
    };
