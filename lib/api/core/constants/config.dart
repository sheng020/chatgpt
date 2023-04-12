import 'package:flutter_chatgpt_clone/api/instance/openai.dart';
import 'package:meta/meta.dart';

@immutable
@internal
abstract class OpenAIConfig {
  //static String get baseUrl => "https://api.openai.com";
  static String get version => "v1";
  static String get baseUrl => OpenAI.baseUrl;
}
