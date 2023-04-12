

import 'package:flutter_chatgpt_clone/features/chat/chat_injection_container.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'database/database.dart';

final sl = GetIt.instance;
final GetStorage box = GetStorage();

Future<void> init()async{
  await GetStorage.init();
  await DatabaseManager.getInstance().initialize();

  final http.Client httpClient = http.Client();

  sl.registerLazySingleton<http.Client>(() => httpClient);


  await chatInjectionContainer();
}