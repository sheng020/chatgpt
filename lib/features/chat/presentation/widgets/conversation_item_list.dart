import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/api/instance/chat/chat_models.dart';
import 'package:flutter_chatgpt_clone/api/instance/openai.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_user_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/conversation_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/left_nav_button_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/common/common.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';
import 'package:flutter_chatgpt_clone/main.dart';

class ConversationItemList extends StatelessWidget {
  ConversationItemList({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return SizedBox();
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: 300,
        decoration:
            BoxDecoration(boxShadow: glowBoxShadow, color: Colors.black87),
        child: Column(
          children: [
            Expanded(
                child: ConversationWidget(onConversationTap: (conversationId) {
              BlocProvider.of<ChatConversationCubit>(context)
                  .selectConversation(conversationId);
            })),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 0.50,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white70),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  BlocProvider.of<ChatConversationCubit>(context)
                      .deleteAllConversation();
                },
                child: LeftNavButtonWidget(
                    iconData: Icons.delete_outline_outlined,
                    textData: "Clear Conversation"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () async {
                  var settingsParams = await _showSettingsDialog(context);
                  if (settingsParams != null) {
                    var serverAdress = settingsParams[0];
                    if (serverAdress.isNotEmpty) {
                      box.write(SERVER_ADDRESS, serverAdress);
                      OpenAI.baseUrl = serverAdress;
                    }

                    var apiKey = settingsParams[1];
                    if (apiKey.isNotEmpty) {
                      box.write(API_KEY, apiKey);
                      OpenAI.apiKey = apiKey;
                    }
                  }
                },
                child: LeftNavButtonWidget(
                    iconData: Icons.ios_share_sharp, textData: "Settings"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () async {
                  var name = await _showTextInputDialog(
                      context, S.of(context).change_name, "input your name");
                  if (name == null) {
                    return;
                  }
                  if (name.isEmpty) {
                    name = DEFAULT_NAME;
                  } else {
                    BlocProvider.of<ChatUserNameCubit>(context)
                        .changeUserName(name);
                  }
                },
                child: LeftNavButtonWidget(
                    iconData: Icons.exit_to_app,
                    textData: S.of(context).change_name),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }
  }

  final _textFieldController = TextEditingController();

  Widget _getTips(BuildContext context, bool showToast) {
    if (showToast) {
      return Text(
        "Delete last slash in the url",
        style: TextStyle(color: Colors.red),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future<List<String>?> _showSettingsDialog(BuildContext context) {
    var serverTextController = TextEditingController();
    var apiKeyTextController = TextEditingController();
    var showToast = false;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, stateSetter) {
            return AlertDialog(
              title: Text("Settings"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getTips(context, showToast),
                  TextField(
                    controller: serverTextController,
                    decoration: InputDecoration(hintText: "input your server"),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: apiKeyTextController,
                    decoration: InputDecoration(hintText: "input your key"),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Model"),
                      SizedBox(
                        width: 8,
                      ),
                      DropdownButton(
                          value: OpenAI.chatModel,
                          items: ChatModel.values
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.name)))
                              .toList(),
                          onChanged: (value) {
                            stateSetter(() {
                              OpenAI.chatModel = value!;
                            });
                            box.write(CHAT_MODEL, value!.name);
                          })
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(S.of(context).cancel),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text(S.of(context).ok),
                  onPressed: () {
                    var serverAddress = serverTextController.text;
                    if (serverAddress.endsWith("/")) {
                      stateSetter.call(() {
                        showToast = true;
                      });
                    } else {
                      Navigator.pop(
                          context,
                          List.generate(2, (index) {
                            if (index == 0) {
                              return serverTextController.text;
                            } else {
                              return apiKeyTextController.text;
                            }
                          }));
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future<String?> _showTextInputDialog(
      BuildContext context, String title, String hint) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: hint),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(S.of(context).cancel),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text(S.of(context).ok),
                onPressed: () =>
                    Navigator.pop(context, _textFieldController.text),
              ),
            ],
          );
        });
  }
}
