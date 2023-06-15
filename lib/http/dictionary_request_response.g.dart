// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictionaryRequest _$DictionaryRequestFromJson(Map<String, dynamic> json) =>
    DictionaryRequest(
      json['from'] as String,
      json['word'] as String,
      json['to'] as String,
      json['timestamp'] as int,
      json['nonce'] as String,
      json['sig'] as String,
    )..app_key = json['app_key'] as String? ?? 'dba0796f0922';

Map<String, dynamic> _$DictionaryRequestToJson(DictionaryRequest instance) =>
    <String, dynamic>{
      'app_key': instance.app_key,
      'to': instance.to,
      'word': instance.word,
      'from': instance.from,
      'timestamp': instance.timestamp,
      'nonce': instance.nonce,
      'sig': instance.sig,
    };

DictionaryResponse _$DictionaryResponseFromJson(Map<String, dynamic> json) =>
    DictionaryResponse(
      json['code'] as int,
      Data.fromJson(json['data'] as Map<String, dynamic>),
      json['message'] as String?,
    );

Map<String, dynamic> _$DictionaryResponseToJson(DictionaryResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['word'] as String,
      json['pronunciation'] as String?,
      json['translated'] as String,
      (json['definitions'] as List<dynamic>?)
          ?.map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['interpretations'] as List<dynamic>?)
          ?.map((e) => Interpretation.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['wiki'] == null
          ? null
          : Wiki.fromJson(json['wiki'] as Map<String, dynamic>),
      json['uk_audio'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'word': instance.word,
      'pronunciation': instance.pronunciation,
      'uk_audio': instance.uk_audio,
      'translated': instance.translated,
      'definitions': instance.definitions,
      'interpretations': instance.interpretations,
      'wiki': instance.wiki,
    };

Definition _$DefinitionFromJson(Map<String, dynamic> json) => Definition(
      json['source'] as String?,
      json['target'] as String?,
      json['speechPart'] as String?,
      (json['example'] as List<dynamic>?)
          ?.map((e) => Example.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DefinitionToJson(Definition instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
      'speechPart': instance.speechPart,
      'example': instance.example,
    };

Example _$ExampleFromJson(Map<String, dynamic> json) => Example(
      json['source'] as String?,
      json['target'] as String?,
    );

Map<String, dynamic> _$ExampleToJson(Example instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

Wiki _$WikiFromJson(Map<String, dynamic> json) => Wiki(
      json['content'] as String?,
      json['url'] as String?,
    );

Map<String, dynamic> _$WikiToJson(Wiki instance) => <String, dynamic>{
      'content': instance.content,
      'url': instance.url,
    };

Phrase _$PhraseFromJson(Map<String, dynamic> json) => Phrase(
      json['source'] as String?,
      json['target'] as String?,
    );

Map<String, dynamic> _$PhraseToJson(Phrase instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

Interpretation _$InterpretationFromJson(Map<String, dynamic> json) =>
    Interpretation(
      (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$InterpretationToJson(Interpretation instance) =>
    <String, dynamic>{
      'sources': instance.sources,
      'targets': instance.targets,
    };
