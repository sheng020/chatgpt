// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslateResponse _$TranslateResponseFromJson(Map<String, dynamic> json) =>
    TranslateResponse(
      code: json['code'] as int,
      message: json['message'] as String?,
      engine: json['engine'] as String,
      data: TranslateResult.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TranslateResponseToJson(TranslateResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'engine': instance.engine,
      'data': instance.data,
    };

TranslateResult _$TranslateResultFromJson(Map<String, dynamic> json) =>
    TranslateResult(
      source: json['source'] as String,
      texts: (json['texts'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TranslateResultToJson(TranslateResult instance) =>
    <String, dynamic>{
      'source': instance.source,
      'texts': instance.texts,
    };
