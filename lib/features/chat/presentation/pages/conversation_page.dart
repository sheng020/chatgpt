import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_message_single_item.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/example_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/left_nav_button_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/common/common.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/custom_text_field.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';
import 'package:flutter_chatgpt_clone/main.dart';

import '../../../../api/instance/openai.dart';
import '../../../../generated/l10n.dart';
import '../cubit/chat_conversation/chat_conversation_user_cubit.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController _messageController = TextEditingController();
  bool _isRequestProcessing = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });
    Future.microtask(() {
      BlocProvider.of<ChatConversationCubit>(context).initMessageList();
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_scrollController.hasClients) {
      Timer(
        Duration(milliseconds: 100),
        () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.decelerate),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 300,
                  decoration: BoxDecoration(
                      boxShadow: glowBoxShadow, color: Colors.black87),
                  child: Column(
                    children: [
                      Expanded(child: BlocBuilder<ChatConversationCubit,
                          ChatConversationState>(
                        builder: (context, chatConversationState) {
                          if (chatConversationState is ChatConversationLoaded) {
                            return ListView.builder(
                                itemCount:
                                    chatConversationState.chatMessages.length +
                                        1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: InkWell(
                                        onTap: () {
                                          if (chatConversationState
                                                  .showConversationId !=
                                              INVALID_CONVERSATION_ID) {
                                            BlocProvider.of<
                                                        ChatConversationCubit>(
                                                    context)
                                                .newConversation();
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Text(
                                            S.of(context).new_chat,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    var realIndex = index - 1;
                                    var entry = chatConversationState
                                        .chatMessages.values
                                        .elementAt(realIndex);
                                    var title = S.of(context).new_conversation;
                                    if (entry.isNotEmpty &&
                                        (entry.first.queryPrompt?.isNotEmpty ??
                                            false)) {
                                      title = entry.first.queryPrompt!;
                                    }
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<
                                                      ChatConversationCubit>(
                                                  context)
                                              .selectConversation(
                                                  chatConversationState
                                                      .chatMessages.keys
                                                      .elementAt(realIndex));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Text(
                                            title,
                                            maxLines: 2,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                });
                          } else {
                            return Container();
                          }
                        },
                      )),
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
                      LeftNavButtonWidget(
                          iconData: Icons.delete_outline_outlined,
                          textData: "Clear Conversation"),
                      SizedBox(
                        height: 10,
                      ),
                      LeftNavButtonWidget(
                          iconData: Icons.nightlight_outlined,
                          textData: "Dark Mode"),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          var apiKey = await _showTextInputDialog(
                              context, "Set api key", "input your key");
                          if (apiKey != null && apiKey.isNotEmpty) {
                            box.write(API_KEY, apiKey);
                            OpenAI.apiKey = apiKey;
                          }
                        },
                        child: LeftNavButtonWidget(
                            iconData: Icons.ios_share_sharp,
                            textData: "Set api key"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          var name = await _showTextInputDialog(context,
                              S.of(context).change_name, "input your name");
                          if (name == null) {
                            return;
                          }
                          if (name.isEmpty) {
                            name = DEFAULT_NAME;
                          } else {
                            BlocProvider.of<ChatUserNameCubit>(context)
                                .changeUserName(name!);
                          }
                        },
                        child: LeftNavButtonWidget(
                            iconData: Icons.exit_to_app,
                            textData: S.of(context).change_name),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(52, 53, 64, 1)),
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<ChatConversationCubit,
                                ChatConversationState>(
                            builder: (context, chatConversationState) {
                          if (chatConversationState is ChatConversationLoaded) {
                            final chatMessages =
                                chatConversationState.getShowMessageList();

                            if (chatMessages == null || chatMessages.isEmpty) {
                              return ExampleWidget(
                                onMessageController: (message) {
                                  setState(() {
                                    _messageController.value =
                                        TextEditingValue(text: message);
                                  });
                                },
                              );
                            } else {
                              return ListView.builder(
                                itemCount: _calculateListItemLength(
                                    chatMessages.length),
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  if (index >= chatMessages.length) {
                                    return _responsePreparingWidget();
                                  } else {
                                    return ChatMessageSingleItem(
                                      chatMessage: chatMessages[index],
                                    );
                                  }
                                },
                              );
                            }
                          }
                          return ExampleWidget(
                            onMessageController: (message) {
                              setState(() {
                                _messageController.value =
                                    TextEditingValue(text: message);
                              });
                            },
                          );
                        }),
                      ),
                      BlocBuilder<ChatConversationCubit, ChatConversationState>(
                        builder: (context, chatConversationState) {
                          if (chatConversationState is ChatConversationLoaded) {
                            return CustomTextField(
                              isRequestProcessing: _isRequestProcessing,
                              textEditingController: _messageController,
                              onTap: () async {
                                _promptTrigger(
                                    chatConversationState.showConversationId);
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 90),
                        child: Text(
                          "ChatGPT Jan 30 Version. Free Research Preview. Our goal is to make AI systems more natural and safe to interact with. Your feedback will help us improve.",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  int _calculateListItemLength(int length) {
    if (!_isRequestProcessing) {
      return length;
    } else {
      return length + 1;
    }
  }

  final _textFieldController = TextEditingController();

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

  Widget _responsePreparingWidget() {
    return Container(
      height: 60,
      child: Image.asset("assets/loading_response.gif"),
    );
  }

  void _promptTrigger(int conversationId) {
    if (_messageController.text.isEmpty) {
      return;
    }

    final humanChatMessage = ChatMessageEntity(
      conversationId: conversationId,
      messageId: ChatGptConst.Human,
      queryPrompt: _messageController.text,
    );

    BlocProvider.of<ChatConversationCubit>(context)
        .chatConversation(
            conversationId: conversationId,
            chatMessage: humanChatMessage,
            onCompleteReqProcessing: (isRequestProcessing) {
              setState(() {
                _isRequestProcessing = isRequestProcessing;
              });
            })
        .then((value) {
      setState(() {
        _messageController.clear();
      });
      if (_scrollController.hasClients) {
        Timer(
          Duration(milliseconds: 100),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate),
        );
      }
    });
  }
}
