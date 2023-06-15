import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chatgpt_clone/http/rest_client.dart';
import 'package:random_string/random_string.dart';

import 'dictionary_request_response.dart';

const APP_KEY = "dba0796f0922";

class HttpClient {
  static HttpClient? _instance;

  final RestClient client;

  // 私有的命名构造函数
  HttpClient._internal()
      : client = RestClient(Dio(
          BaseOptions(
              baseUrl: "https://atominfo.services",
              headers: {'Content-Type': 'application/json'}),
        ));

  static HttpClient getInstance() {
    _instance ??= HttpClient._internal();

    return _instance!;
  }

  static String TOKEN_CHARACTER =
      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

  Future<DictionaryResponse> requestDictionary(
      {required String from,
      required String str,
      required String to,
      required int sendTime}) {
    StringBuffer tokenBuffer = StringBuffer();
    for (int i = 0; i < 4; i++) {
      var index = randomBetween(0, TOKEN_CHARACTER.length - 1);
      tokenBuffer.write(TOKEN_CHARACTER[index]);
    }
    var token = tokenBuffer.toString();

    var time = DateTime.now().millisecondsSinceEpoch;

    var bytes = utf8.encode("$APP_KEY$time$token");
    var digest = sha1.convert(bytes);

    return client.searchDictionary(
        APP_KEY, from, to, str, time, token, digest.toString());
    /*return client.searchDictionary(DictionaryRequest(
        from, str, to, sendTime, "hF5C", "fc67a8c7c07369ab90ae19ba00986f25"));*/
  }
}
