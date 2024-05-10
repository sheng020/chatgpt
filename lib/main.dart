import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/api/instance/chat/chat_models.dart';
import 'package:flutter_chatgpt_clone/features/app/route/on_generate_route.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_user_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/pages/conversation_page.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'api/instance/openai.dart';
import 'env.dart';
import 'generated/l10n.dart';
import 'injection_container.dart' as di;

const PROXY_ADDRESS = "proxy_address";
const API_KEY = "api_key";
const SERVER_ADDRESS = "server_address";
const CHAT_MODEL = "chat_model";
const DEFAULT_KEY = Env.DEFAULT_KEY;
const DEFAULT_SERVER = Env.DEFAULT_SERVER;

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ///这里如果有自己搭建服务器的可以自己设置服务器域名，格式如下：
  ///https://your_client_adress.com
  ///注意最后没有/
  ///没有的话也可以不设置，默认是OpenAI的域名，但是需要翻墙才能访问
  ///OpenAI.baseUrl = "your client address";
  Future<void> initEnv() async {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();
    String? apiKey = box.read(API_KEY);
    if (apiKey == null || apiKey.isEmpty) {
      apiKey = DEFAULT_KEY;
    }
    String? serverAddress = box.read(SERVER_ADDRESS);
    if (serverAddress == null || serverAddress.isEmpty) {
      serverAddress = DEFAULT_SERVER;
    }
    OpenAI.baseUrl = serverAddress;
    OpenAI.apiKey = apiKey;

    String modelName = box.read(CHAT_MODEL) ?? ChatModel.GPT_3_5_TURBO.name;
    OpenAI.chatModel = ChatModel.values.firstWhere(
          (element) => element.name == modelName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: initEnv(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Container();
        } else {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => di.sl<ChatConversationCubit>(),
              ),
              BlocProvider(
                create: (_) => di.sl<ChatUserNameCubit>(),
              ),
            ],
            child: MaterialApp(
              restorationScopeId: "ChatGpt",
              title: 'ChatGpt',
              theme: ThemeData(brightness: Brightness.dark),
              initialRoute: '/',
              debugShowCheckedModeBanner: false,
              onGenerateRoute: OnGenerateRoute.route,
              routes: {
                "/": (context) {
                  return ConversationPage();
                }

                // add dark and light theme.
                // chatMessages history
              },
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            ),
          );
        }
      } else {
        return Container();
      }

    });

  }
}
