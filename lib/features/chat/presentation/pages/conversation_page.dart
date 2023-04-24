import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_message_single_item.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/custom_standard_fab_location.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/example_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/left_nav_button_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/common/common.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/custom_text_field.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';
import 'package:flutter_chatgpt_clone/main.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  ScrollController _scrollController = ScrollController();
  var _isScrollViewFirstLoad = true;

  @override
  void initState() {
    Future.microtask(() async {
      await BlocProvider.of<ChatConversationCubit>(context).initMessageList();
      /* Future.delayed(Duration(milliseconds: 500), () {
        _scrollController.position
            .jumpTo(_scrollController.position.maxScrollExtent);
      }); */
    });
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels -
                  _scrollController.position.maxScrollExtent)
              .abs() >
          200) {
        if (!_isVisible) {
          BlocProvider.of<ChatConversationCubit>(context)
              .setFloatingActionButtonShow(true);
          _isVisible = true;
        }
      } else {
        if (_isVisible) {
          BlocProvider.of<ChatConversationCubit>(context)
              .setFloatingActionButtonShow(false);
          _isVisible = false;
        }
      }
    });

    super.initState();
  }

  var _isVisible = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Size? lastItemSize;
  Map<String, GlobalKey> keyMaps = {};

  GlobalKey getCachedKey(String key) {
    if (keyMaps.containsKey(key)) {
      return keyMaps[key]!;
    } else {
      GlobalKey value = GlobalKey();
      keyMaps[key] = value;
      return value;
    }
  }

  String getKeyAtIndex(String messageId, int index) {
    return "index_${messageId}_$index";
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
                      Expanded(
                          child: BlocBuilder<ChatConversationCubit,
                              ChatConversationState>(
                        buildWhen: (previous, current) =>
                            current is ChatConversationLoaded,
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
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          onTap: () {
                                            if (chatConversationState
                                                    .showConversationId !=
                                                INVALID_CONVERSATION_ID) {
                                              BlocProvider.of<
                                                          ChatConversationCubit>(
                                                      context)
                                                  .newConversation();
                                              _isVisible = false;
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
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
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          onTap: () {
                                            BlocProvider.of<
                                                        ChatConversationCubit>(
                                                    context)
                                                .selectConversation(
                                                    chatConversationState
                                                        .chatMessages.keys
                                                        .elementAt(realIndex));
                                            if (_scrollController.hasClients) {
                                              _scrollController.jumpTo(
                                                  _scrollController
                                                      .position.pixels);
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
                                              title,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
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
                                  List<Widget> children = [];
                                  var index = 0;
                                  for (var chatMessage in chatMessages) {
                                    var widgetKey = getCachedKey(getKeyAtIndex(
                                        chatMessage.messageId ?? "", index));
                                    var widget = VisibilityDetector(
                                      key: widgetKey,
                                      onVisibilityChanged:
                                          (VisibilityInfo visibilityInfo) {
                                        var visiblePercentage =
                                            visibilityInfo.visibleFraction *
                                                100;
                                        var key =
                                            visibilityInfo.key as GlobalKey;
                                        String? mapKey;
                                        for (var entry in keyMaps.entries) {
                                          if (entry.value == key) {
                                            mapKey = entry.key;
                                            break;
                                          }
                                        }

                                        if (chatConversationState
                                                .isRequestProcessing &&
                                            mapKey ==
                                                getKeyAtIndex(
                                                    chatMessage.messageId ?? "",
                                                    chatMessages.length - 1)) {
                                          //if last widget height has changed.
                                          var currentSize =
                                              widgetKey.currentContext?.size;
                                          if (lastItemSize != currentSize) {
                                            if (visiblePercentage < 100 &&
                                                visiblePercentage > 0) {
                                              Scrollable.ensureVisible(
                                                  widgetKey.currentContext!,
                                                  duration: Duration(
                                                      milliseconds: 150),
                                                  curve: Curves.decelerate,
                                                  alignmentPolicy:
                                                      ScrollPositionAlignmentPolicy
                                                          .keepVisibleAtEnd);
                                            }
                                            lastItemSize = currentSize;
                                          }
                                        }
                                      },
                                      child: ChatMessageSingleItem(
                                        /* key: getCachedKey(
                                            "index_${chatMessage.messageId}_${index}"), */
                                        chatMessage: chatMessage,
                                      ),
                                    );
                                    children.add(widget);
                                    index++;
                                  }
                                  if (chatConversationState
                                      .isRequestProcessing) {
                                    children.add(_responsePreparingWidget());
                                  }

                                  if (_isScrollViewFirstLoad) {
                                    _isScrollViewFirstLoad = false;
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      _scrollController.position.jumpTo(
                                          _scrollController
                                              .position.maxScrollExtent);
                                    });
                                  }

                                  Widget stopGenerating;
                                  if (chatConversationState
                                      .isRequestProcessing) {
                                    stopGenerating = Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.black45,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              24)))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: Text(
                                              "Stop generating.",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<
                                                        ChatConversationCubit>(
                                                    context)
                                                .stopGeneration();
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    stopGenerating = SizedBox.shrink();
                                  }

                                  return Stack(
                                    children: [
                                      SingleChildScrollView(
                                        controller: _scrollController,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 32),
                                          child: Column(
                                            children: children,
                                          ),
                                        ),
                                      ),
                                      stopGenerating
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
                              textEditingController: _messageController,
                              onTap: () async {
                                _promptTrigger(chatConversationState
                                    .selectedConversationId);
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
                  if (_scrollController.position.pixels !=
                      _scrollController.position.maxScrollExtent) {
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
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

  /* int _calculateListItemLength(int length, bool isRequestProcessing) {
    if (!isRequestProcessing) {
      return length;
    } else {
      return length + 1;
    }
  } */

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
              /* setState(() {
                _isRequestProcessing = isRequestProcessing;
              }); */
            })
        .then((value) {
      //BlocProvider.of<ChatConversationCubit>(context).sendChatMessage("");
      /* setState(() {
        _messageController.clear();
      }); */
      if (_scrollController.hasClients) {
        Timer(
          Duration(milliseconds: 100),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 150),
              curve: Curves.ease),
        );
      }
    });
  }
}
