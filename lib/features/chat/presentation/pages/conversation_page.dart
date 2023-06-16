import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/purchase_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_messages_list_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/custom_standard_fab_location.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/example_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/stop_generate_widget.dart';
import 'package:flutter_chatgpt_clone/features/global/channel/native_channel.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/const/constants.dart';
import 'package:flutter_chatgpt_clone/features/global/input/custom_text_field.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
      if (isNewUser()) {
        await Navigator.of(context).pushNamed("/discounts");
      }
      await BlocProvider.of<ChatConversationCubit>(context).initMessageList();
      /* Future.delayed(Duration(milliseconds: 500), () {
        _scrollController.position
            .jumpTo(_scrollController.position.maxScrollExtent);
      }); */
      BlocProvider.of<PurchaseCubit>(context).loadRewardAdIfAvaliable();
      BlocProvider.of<PurchaseCubit>(context).checkIsPurchase();
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
      if (inputMode.value == TYPE_REAL_TIME_TRANSLATE) {
        startRealTimeTranslate(_messageController.text);
      }
    });

    super.initState();
  }

  void startRealTimeTranslate(String text) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 500), () {
      BlocProvider.of<ChatConversationCubit>(context)
          .startRealTimeTranslate(text);
    });
  }

  Timer? timer;

  //var _isVisible = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 8.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24.w,
              ),
              SvgPicture.asset("assets/images/ic_logo.svg"),
              SizedBox(
                width: 4.w,
              ),
              BlocBuilder<PurchaseCubit, PurchaseState>(
                  builder: (context, purchaseState) {
                if (purchaseState.isPurchased) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                      ),
                      SvgPicture.asset("assets/images/ic_vip_logo.svg")
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
              Spacer(),
              BlocBuilder<PurchaseCubit, PurchaseState>(
                  builder: (context, purchaseState) {
                if (purchaseState.isPurchased) {
                  return SizedBox.shrink();
                } else {
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<PurchaseCubit>(context)
                          .openSubscriptionPage();
                    },
                    child: Image.asset(
                      "assets/images/ic_vip_entrance.png",
                      width: 54.w,
                      height: 24.h,
                    ),
                  );
                }
              }),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/settings");
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ))
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          Expanded(
            child: BlocBuilder<ChatConversationCubit, ChatConversationState>(
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
                          ChatMessagesListWidget(
                              editingController: _messageController,
                              chatMessages: chatMessages,
                              isRequestProcessing:
                                  chatConversationState.isRequestProcessing,
                              scrollController: _scrollController),
                          StopGenerateWidget(
                              type: inputMode.value,
                              isRequestProcessing:
                                  chatConversationState.isRequestProcessing)
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
          BlocBuilder<PurchaseCubit, PurchaseState>(
              builder: (context, purchaseState) {
            if (purchaseState.isPurchased) {
              return SizedBox.shrink();
            } else {
              return BlocBuilder<ChatConversationCubit, ChatConversationState>(
                builder: (context, leftCountState) {
                  if (leftCountState is ConversationLeftCount) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        S
                            .of(context)
                            .opportunitie_remaining(leftCountState.leftCount),
                        style: TextStyle(
                            color: Color(0xFF21D8E8),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
                buildWhen: (previous, current) {
                  return current is ConversationLeftCount;
                },
              );
            }
          }),
          BlocBuilder<ChatConversationCubit, ChatConversationState>(
            buildWhen: (previous, current) => current is NotifyTextFieldState,
            builder: (context, chatConversationState) {
              if (chatConversationState is NotifyTextFieldState) {
                /* if (chatConversationState.isRequestProcessing) {
                  _messageController.text = "";
                } else {
                  _messageController.value =
                      TextEditingValue(text: chatConversationState.message);
                } */

                return Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: inputMode,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          if (value == TYPE_REAL_TIME_TRANSLATE) {
                            if (chatConversationState.translation != null) {
                              return Container(
                                height: 48.h,
                                color: Color(0xFF3A4154),
                                child: Row(children: [
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/ic_translate_logo.svg"),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                      child: Text(
                                    chatConversationState.translation!,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      onTap: () {
                                        if (chatConversationState.translation !=
                                            null) {
                                          _messageController.text =
                                              chatConversationState
                                                  .translation!;
                                          _messageController.selection =
                                              TextSelection.collapsed(
                                                  offset: _messageController
                                                      .text.length);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            S.of(context).usage,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF298DFF)),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          SvgPicture.asset(
                                              "assets/images/ic_down_arrow.svg"),
                                          SizedBox(
                                            width: 12.w,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                    CustomTextField(
                      isRequestProcessing:
                          chatConversationState.isRequestProcessing,
                      inputMode: inputMode,
                      textEditingController: _messageController,
                      textInputNotifier: textInputNotifier,
                      onTap: (int type, {String? path}) async {
                        var leftCount = getLeftCount();
                        var isPurchased = await NativeChannel.isPurchased();
                        if (leftCount <= 0 && !isPurchased) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(S.of(context).no_chance_left),
                            duration: Duration(seconds: 2),
                          ));
                        } else {
                          _promptTrigger(type: type, path: path);
                        }
                      },
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
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
          offsetX: -16,
          offsetY: -120),
    );
  }

  void _promptTrigger({required int type, String? path}) {
    if (_messageController.text.isEmpty) {
      if (type != TYPE_IMAGE_VARIATION) {
        return;
      }
    }

    final ChatMessageEntity humanChatMessage;

    if (type != TYPE_IMAGE_VARIATION) {
      humanChatMessage = ChatMessageEntity(
          messageId: ChatGptConst.Human,
          type: TYPE_CHAT,
          queryPrompt: _messageController.text,
          date: DateTime.now().millisecondsSinceEpoch);
    } else {
      humanChatMessage = ChatMessageEntity(
          messageId: ChatGptConst.Human,
          type: type,
          queryPrompt: path,
          date: DateTime.now().millisecondsSinceEpoch);
    }

    var chatConversationCubit = BlocProvider.of<ChatConversationCubit>(context);
    chatConversationCubit
        .chatConversation(type: type, chatMessage: humanChatMessage)
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
