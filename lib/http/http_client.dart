import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chatgpt_clone/api/core/builder/headers.dart';
import 'package:flutter_chatgpt_clone/http/rest_client.dart';
import 'package:flutter_chatgpt_clone/http/translate_response.dart';
import 'package:flutter_chatgpt_clone/main.dart';
import 'package:random_string/random_string.dart';

import 'dictionary_request_response.dart';

const APP_KEY_NORMAL = "ce16cb3b7a24";
const PACKAGE_NAME_NORMAL = "com.atom.android.chatgpt";
const String TOKEN_CHARACTER =
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
const String serverApiKeyNormal = "9644b3f644474eada3d75657cd690e57";
const String serverSecretNormal = "05ba1e0b-18a9-431b-b2a6-49c0dfdb73da";
const String languageTag = "zh";

const APP_KEY_VIP = "ce16cb3b7a24";
const PACKAGE_NAME_VIP = "com.atom.android.chatgpt.sub";
const serverApiKeyVip =
    "9644b3f644474eada3d75657cd690e579644b3f644474eada3d75657cd690e57";
const String serverSecretVip = "05ba1e0b-18a9-431b-b2a6-49c0dfdb73da";

class HttpClient {
  static HttpClient? _instance;

  final RestClient client;

  static var APP_KEY = APP_KEY_NORMAL;
  static var PACKAGE_NAME = PACKAGE_NAME_NORMAL;
  static String serverApiKey = serverApiKeyNormal;
  static String serverSecret = serverSecretNormal;

  // 私有的命名构造函数
  HttpClient._internal()
      : client = RestClient(Dio(
          BaseOptions(
              baseUrl: "http://18.157.84.26:8081",
              headers: HeadersBuilder.build()),
        ));

  static HttpClient getInstance() {
    _instance ??= HttpClient._internal();

    return _instance!;
  }

  Future<DictionaryResponse> requestDictionary(
      {required String from,
      required String str,
      required String to,
      required int sendTime}) {
    var token = generateToken();

    var time = DateTime.now().millisecondsSinceEpoch;

    var digest = generateSignature(time, token);

    return client.searchDictionary(
        APP_KEY, from, to, str, time, token, digest.toString());
    /*return client.searchDictionary(DictionaryRequest(
        from, str, to, sendTime, "hF5C", "fc67a8c7c07369ab90ae19ba00986f25"));*/
  }

  Future<TranslateResponse> translate(
      {required String to, required List<String> texts}) {
    return client.translate(to, texts);
  }
}

//val randomKey = "${serverAppKey}&$toLangCode&$timeStamp&${serverSecret}&$random"

String generateSignature(int time, String token) {
  var bytes = utf8.encode(
      "${HttpClient.APP_KEY}&${languageTag}&$time&${HttpClient.serverSecret}&$token");

  /* bytes = utf8.encode(
      "ce16cb3b7a24&zh&1686807585&05ba1e0b-18a9-431b-b2a6-49c0dfdb73da&nmNU"); */
  var digest = md5.convert(bytes);
  return digest.toString();
}

String generateToken() {
  StringBuffer tokenBuffer = StringBuffer();
  for (int i = 0; i < 4; i++) {
    var index = randomBetween(0, TOKEN_CHARACTER.length - 1);
    tokenBuffer.write(TOKEN_CHARACTER[index]);
  }
  var token = tokenBuffer.toString();
  return token;
}
