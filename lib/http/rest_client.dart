import 'package:dio/dio.dart';
import 'package:flutter_chatgpt_clone/http/translate_response.dart';

import 'package:retrofit/retrofit.dart';

import 'dictionary_request_response.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/v1/api/dictionary")
  Future<DictionaryResponse> searchDictionary(
      @Field("app_key") String appKey,
      @Field("from") String from,
      @Field("to") String to,
      @Field("word") String word,
      @Field("timestamp") int timestamp,
      @Field("nonce") String nonce,
      @Field("sig") String sig);

  @POST("/v1/api/translate")
  Future<TranslateResponse> translate(
      @Field("to") String to, @Field("texts") List<String> texts);
}
