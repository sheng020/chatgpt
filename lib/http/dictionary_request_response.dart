import 'package:json_annotation/json_annotation.dart';
part 'dictionary_request_response.g.dart';

@JsonSerializable()
class DictionaryRequest {
  @JsonKey(name: "app_key", defaultValue: "dba0796f0922")
  String app_key = "dba0796f0922";
  String to;
  String word;
  String from;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String nonce = "hF5C";
  String sig = "fc67a8c7c07369ab90ae19ba00986f25";

  DictionaryRequest(
      this.from, this.word, this.to, this.timestamp, this.nonce, this.sig);

  factory DictionaryRequest.fromJson(Map<String, dynamic> json) =>
      _$DictionaryRequestFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DictionaryRequestToJson(this);
}

@JsonSerializable()
class DictionaryResponse {
  final int code;
  final Data data;
  String? message;

  DictionaryResponse(this.code, this.data, this.message);

  factory DictionaryResponse.fromJson(Map<String, dynamic> json) =>
      _$DictionaryResponseFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DictionaryResponseToJson(this);

  //判断是否在词典里面
  bool inDictionaryBook() {
    return data.definitions != null && data.definitions!.isNotEmpty;
  }

  DictionaryResponse.translation(String word, String translated)
      : code = 1000,
        data = Data(word, null, translated, null, null, null, null);
}

@JsonSerializable()
class Data {
  final String word;
  final String? pronunciation;
  final String? uk_audio;
  final String translated;
  final List<Definition>? definitions;

  //List<Phrase>? phrases;

  //List<String>? synonyms;

  List<Interpretation>? interpretations;

  Wiki? wiki;

  Data(
      this.word,
      this.pronunciation,
      this.translated,
      this.definitions,
      /*this.phrases, this.synonyms,*/ this.interpretations,
      this.wiki,
      this.uk_audio);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Definition {
  String? source;

  String? target;

  String? speechPart;

  List<Example>? example;

  Definition(this.source, this.target, this.speechPart, this.example);

  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DefinitionToJson(this);
}

@JsonSerializable()
class Example {
  String? source;
  String? target;

  Example(this.source, this.target);

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ExampleToJson(this);
}

@JsonSerializable()
class Wiki {
  String? content;
  String? url;

  Wiki(this.content, this.url);

  factory Wiki.fromJson(Map<String, dynamic> json) => _$WikiFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$WikiToJson(this);
}

@JsonSerializable()
class Phrase {
  String? source;

  String? target;

  Phrase(this.source, this.target);

  factory Phrase.fromJson(Map<String, dynamic> json) => _$PhraseFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhraseToJson(this);
}

@JsonSerializable()
class Interpretation {
  List<String>? sources;
  List<String>? targets;

  Interpretation(this.sources, this.targets);

  factory Interpretation.fromJson(Map<String, dynamic> json) =>
      _$InterpretationFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$InterpretationToJson(this);
}
