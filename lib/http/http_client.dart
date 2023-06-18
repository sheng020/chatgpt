import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chatgpt_clone/api/core/builder/headers.dart';
import 'package:flutter_chatgpt_clone/http/rest_client.dart';
import 'package:flutter_chatgpt_clone/http/translate_response.dart';
import 'package:flutter_chatgpt_clone/main.dart';
import 'package:random_string/random_string.dart';

import 'dictionary_request_response.dart';

/* {'com.atom.android.chatgpt': {'secret': "05ba1e0b-18a9-431b-b2a6-49c0dfdb73da",
                                       'appkey': 'ce16cb3b7a24',
                                       'apikey': '20ad367860c144ebb4cbc3afe8ad5d61',
                                       },
          'com.atom.android.chatgpt.pro': {'secret': "0338b39c-372f-4eae-923b-bc71e8b5d7d9",
                                           'appkey': '4e6f3640e9e3',
                                           'apikey': '47801fab303b41e3be846c3177d01bb8',
                                           }
          } */
const APP_KEY_NORMAL = "ce16cb3b7a24";
const PACKAGE_NAME_NORMAL = "com.atom.android.chatgpt";
const String TOKEN_CHARACTER =
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
const String serverApiKeyNormal = "20ad367860c144ebb4cbc3afe8ad5d61";
const String serverSecretNormal = "05ba1e0b-18a9-431b-b2a6-49c0dfdb73da";
const String languageTag = "zh";

const APP_KEY_VIP = "4e6f3640e9e3";
const PACKAGE_NAME_VIP = "com.atom.android.chatgpt.pro";
const serverApiKeyVip = "47801fab303b41e3be846c3177d01bb8";
const String serverSecretVip = "0338b39c-372f-4eae-923b-bc71e8b5d7d9";

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
              baseUrl: "https://t2t.atominfo.services",
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
