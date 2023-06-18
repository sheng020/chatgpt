import 'package:json_annotation/json_annotation.dart';
part 'translate_response.g.dart';

@JsonSerializable()
class TranslateResponse {
  final int code;

  final String? message;
  final String engine;
  final TranslateResult data;

  TranslateResponse(
      {required this.code,
      this.message,
      required this.engine,
      required this.data});

  factory TranslateResponse.fromJson(Map<String, dynamic> json) =>
      _$TranslateResponseFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TranslateResponseToJson(this);
}

@JsonSerializable()
class TranslateResult {
  final String source;
  final List<String> texts;

  TranslateResult({required this.source, required this.texts});

  factory TranslateResult.fromJson(Map<String, dynamic> json) =>
      _$TranslateResultFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TranslateResultToJson(this);
}
