import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt_clone/features/chat/chat_injection_container.dart';
import 'package:flutter_flurry_sdk/flurry.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'database/database.dart';

final sl = GetIt.instance;
final GetStorage box = GetStorage();

const FLURRY_ANDROID_API_KEY = "V6BX9XWHYY5SRYJ999F8";
const FLURRY_IOS_API_KEY = "";

Future<void> init() async {
  await GetStorage.init();
  await DatabaseManager.getInstance().initialize();

  Flurry.builder
      .withCrashReporting(true)
      .withLogEnabled(kDebugMode)
      .withLogLevel(LogLevel.debug)
      .build(
          androidAPIKey: FLURRY_ANDROID_API_KEY, iosAPIKey: FLURRY_IOS_API_KEY);

  final http.Client httpClient = http.Client();

  sl.registerLazySingleton<http.Client>(() => httpClient);

  await chatInjectionContainer();
}
