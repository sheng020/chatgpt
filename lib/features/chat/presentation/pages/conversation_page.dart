import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/api/instance/chat/chat_models.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_messages_list_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/conversation_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/custom_standard_fab_location.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/example_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/left_nav_button_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/stop_generate_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/common/common.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/custom_text_field.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';
import 'package:flutter_chatgpt_clone/main.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  //bool _isRequestProcessing = false;

  late AutoScrollController _scrollController;
  final ValueNotifier<int> inputMode = ValueNotifier(TYPE_CHAT);

  @override
  void initState() {
    _scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    Future.microtask(() async {
      await BlocProvider.of<ChatConversationCubit>(context).initMessageList();
      /* Future.delayed(Duration(milliseconds: 500), () {
        _scrollController.position
            .jumpTo(_scrollController.position.maxScrollExtent);
      }); */
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 200) {
        BlocProvider.of<ChatConversationCubit>(context)
            .setFloatingActionButtonShow(true);
      } else {
        BlocProvider.of<ChatConversationCubit>(context)
            .setFloatingActionButtonShow(false);
      }
    });

    super.initState();
  }

  //var _isVisible = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      Expanded(child: ConversationWidget(
                          onConversationTap: (conversationId) {
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
                      /* SizedBox(
                        height: 10,
                      ),
                      LeftNavButtonWidget(
                          iconData: Icons.nightlight_outlined,
                          textData: "Dark Mode"), */
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () async {
                            var settingsParams =
                                await _showSettingsDialog(context);
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
                              var proxyAddress = settingsParams[2];
                              box.write(PROXY_ADDRESS, proxyAddress);
                            }
                          },
                          child: LeftNavButtonWidget(
                              iconData: Icons.ios_share_sharp,
                              textData: "Settings"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
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
                            buildWhen: (previous, current) =>
                                current is ChatConversationLoaded ||
                                current is ChatConversationInitial ||
                                current is ChatConversationLoading,
                            builder: (context, chatConversationState) {
                              if (chatConversationState
                                  is ChatConversationLoaded) {
                                final chatMessages =
                                    chatConversationState.getShowMessageList();

                                if (chatMessages == null ||
                                    chatMessages.isEmpty) {
                                  return ExampleWidget(
                                    onMessageController: (message) {
                                      BlocProvider.of<ChatConversationCubit>(
                                              context)
                                          .sendChatMessage(message);
                                    },
                                  );
                                } else {
                                  /* var chatMessagesReversed =
                                      chatMessages.reversed.toList(); */
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: ChatMessagesListWidget(
                                            chatMessages: chatMessages,
                                            isRequestProcessing:
                                                chatConversationState
                                                    .isRequestProcessing,
                                            scrollController:
                                                _scrollController,
                                            editingController: _messageController),
                                      ),
                                      StopGenerateWidget(
                                          type: inputMode.value,
                                          isRequestProcessing:
                                              chatConversationState
                                                  .isRequestProcessing)
                                    ],
                                  );
                                }
                              }
                              return ExampleWidget(
                                onMessageController: (message) {
                                  BlocProvider.of<ChatConversationCubit>(
                                          context)
                                      .sendChatMessage(message);
                                  /* setState(() {
                                    _messageController.value =
                                        TextEditingValue(text: message);
                                  }); */
                                },
                              );
                            }),
                      ),
                      BlocBuilder<ChatConversationCubit, ChatConversationState>(
                        buildWhen: (previous, current) =>
                            current is NotifyTextFieldState,
                        builder: (context, chatConversationState) {
                          if (chatConversationState is NotifyTextFieldState) {
                            _messageController.value = TextEditingValue(
                                text: chatConversationState.message);
                            return CustomTextField(
                              isRequestProcessing:
                                  chatConversationState.isRequestProcessing,
                              inputMode: inputMode,
                              textEditingController: _messageController,
                              onTap: (int type, {String? path}) async {
                                _promptTrigger(
                                    conversationId: chatConversationState
                                        .selectedConversationId,
                                    type: type,
                                    path: path);
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
      floatingActionButton:
          BlocBuilder<ChatConversationCubit, ChatConversationState>(
        buildWhen: (previous, current) => current is FloatingActionState,
        builder: (context, state) {
          if (state is FloatingActionState) {
            return Visibility(
              visible: state.showFloatingActionButton,
              child: FloatingActionButton(
                backgroundColor: Colors.blueGrey,
                onPressed: () {
                  var chatConversationCubit =
                      BlocProvider.of<ChatConversationCubit>(context);
                  var length =
                      chatConversationCubit.getCurrentConversationLength();
                  if (length >= 1) {
                    _scrollController.scrollToIndex(0,
                        duration: Duration(milliseconds: 500),
                        preferPosition: AutoScrollPosition.end);
                  }
                },
                child: Icon(Icons.file_download_rounded),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      floatingActionButtonLocation: CustomStandardFabLocation(
          location: FloatingActionButtonLocation.endDocked,
          offsetX: -32,
          offsetY: -128),
    );
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
    var proxyTextController = TextEditingController();
    proxyTextController.text = box.read(PROXY_ADDRESS) ?? "";
    serverTextController.text = box.read(SERVER_ADDRESS) ?? "";
    apiKeyTextController.text = box.read(API_KEY) ?? DEFAULT_KEY;
    //print("api key:${apiKeyTextController.text}  ${box.read(API_KEY)}");
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
                  ),
                  TextField(
                    controller: proxyTextController,
                    decoration: InputDecoration(hintText: "proxy, ex: host:port"),
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
                          List.generate(3, (index) {
                            if (index == 0) {
                              return serverTextController.text;
                            } else if (index == 1){
                              return apiKeyTextController.text;
                            } else {
                              return proxyTextController.text;
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

  void _promptTrigger(
      {required int conversationId, required int type, String? path}) {
    if (_messageController.text.isEmpty) {
      if (type != TYPE_IMAGE_VARIATION) {
        return;
      }
    }

    final ChatMessageEntity humanChatMessage;

    if (type != TYPE_IMAGE_VARIATION) {
      humanChatMessage = ChatMessageEntity(
          conversationId: conversationId,
          messageId: ChatGptConst.Human,
          type: TYPE_CHAT,
          queryPrompt: _messageController.text,
          date: DateTime.now().millisecondsSinceEpoch);
    } else {
      humanChatMessage = ChatMessageEntity(
          conversationId: conversationId,
          messageId: ChatGptConst.Human,
          type: type,
          queryPrompt: path,
          date: DateTime.now().millisecondsSinceEpoch);
    }

    var chatConversationCubit = BlocProvider.of<ChatConversationCubit>(context);
    chatConversationCubit
        .chatConversation(
            type: type,
            conversationId: conversationId,
            chatMessage: humanChatMessage)
        .then((value) {
      //BlocProvider.of<ChatConversationCubit>(context).sendChatMessage("");
      /* setState(() {
        _messageController.clear();
      }); */
      if (_scrollController.hasClients) {
        var length = chatConversationCubit.getCurrentConversationLength();
        if (length >= 1) {
          _scrollController.scrollToIndex(0,
              duration: Duration(milliseconds: 100),
              preferPosition: AutoScrollPosition.end);
          /* Timer(
            Duration(milliseconds: 100),
            () => _scrollController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease),
          ); */
        }
      }
    });
  }
}
