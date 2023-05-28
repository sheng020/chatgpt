import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/purchase_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_messages_list_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/conversation_item_list.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/custom_standard_fab_location.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/example_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/stop_generate_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  final ValueNotifier<String> textInputNotifier = ValueNotifier("");

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
      BlocProvider.of<PurchaseCubit>(context).loadRewardAdIfAvaliable();
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

    _messageController.addListener(() {
      textInputNotifier.value = _messageController.text;
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
      body: SafeArea(
          child: Row(
        children: [
          ConversationItemList(),
          Expanded(
              child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                BlocBuilder<PurchaseCubit, PurchaseState>(
                    builder: (context, purchaseState) {
                  if (purchaseState.isPurchased) {
                    return SizedBox.shrink();
                  } else {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 16.w),
                        child: Row(children: [
                          Text("未订阅，订阅可无限使用"),
                          SizedBox(
                            width: 16.w,
                          ),
                          TextButton(
                              onPressed: () {
                                BlocProvider.of<PurchaseCubit>(context)
                                    .startShowRewardAd();
                              },
                              child: Text("去订阅"))
                        ]),
                      ),
                    );
                  }
                }),
                Expanded(
                  child: BlocBuilder<ChatConversationCubit,
                          ChatConversationState>(
                      buildWhen: (previous, current) =>
                          current is ChatConversationLoaded ||
                          current is ChatConversationInitial ||
                          current is ChatConversationLoading,
                      builder: (context, chatConversationState) {
                        if (chatConversationState is ChatConversationLoaded) {
                          final chatMessages =
                              chatConversationState.getShowMessageList();

                          if (chatMessages == null || chatMessages.isEmpty) {
                            return ExampleWidget(
                              onMessageController: (message) {
                                BlocProvider.of<ChatConversationCubit>(context)
                                    .sendChatMessage(message);
                              },
                            );
                          } else {
                            return Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.w),
                                  child: ChatMessagesListWidget(
                                      chatMessages: chatMessages,
                                      isRequestProcessing: chatConversationState
                                          .isRequestProcessing,
                                      scrollController: _scrollController),
                                ),
                                StopGenerateWidget(
                                    type: inputMode.value,
                                    isRequestProcessing: chatConversationState
                                        .isRequestProcessing)
                              ],
                            );
                          }
                        }
                        return ExampleWidget(
                          onMessageController: (message) {
                            BlocProvider.of<ChatConversationCubit>(context)
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
                      if (chatConversationState.isRequestProcessing) {
                        _messageController.text = "";
                      } else {
                        _messageController.value = TextEditingValue(
                            text: chatConversationState.message);
                      }

                      return CustomTextField(
                        isRequestProcessing:
                            chatConversationState.isRequestProcessing,
                        inputMode: inputMode,
                        textEditingController: _messageController,
                        textInputNotifier: textInputNotifier,
                        onTap: (int type, {String? path}) async {
                          _promptTrigger(
                              conversationId:
                                  chatConversationState.selectedConversationId,
                              type: type,
                              path: path);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                /* Container(
                  margin: EdgeInsets.symmetric(horizontal: 90),
                  child: Text(
                    "ChatGPT Jan 30 Version. Free Research Preview. Our goal is to make AI systems more natural and safe to interact with. Your feedback will help us improve.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ), */
                SizedBox(
                  height: 8.h,
                ),
              ],
            ),
          ))
        ],
      )),
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
