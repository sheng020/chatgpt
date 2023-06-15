import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatgpt_clone/api/core/models/image/variation/variation.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/style.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../api/core/models/image/image/image.dart';
import '../cubit/chat_conversation/chat_conversation_cubit.dart';
import '../cubit/chat_conversation/chat_conversation_user_cubit.dart';

class ChatMessageSingleItem extends StatelessWidget {
  final ChatMessageEntity chatMessage;
  final TextEditingController editingController;

  const ChatMessageSingleItem(
      {Key? key, required this.chatMessage, required this.editingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _chatMessageItem(context);
  }

  Widget getResponseWidget(ChatMessageEntity chatMessage) {
    if (chatMessage.type == TYPE_CHAT) {
      return MarkdownWidget(
          shrinkWrap: true,
          selectable: true,
          data: chatMessage.promptResponse!,
          config: MarkdownConfig.darkConfig
          //syntaxHighlighter: Highlighter(),
          );
    } else if (chatMessage.type == TYPE_IMAGE_GENERATION) {
      OpenAIImageModel imageModel =
          OpenAIImageModel.fromJson(json.decode(chatMessage.promptResponse!));
      var children = imageModel.data.map(
        (e) {
          print("image generation:${e.url}");
          return Padding(
            padding: EdgeInsets.all(8.r),
            child: CachedNetworkImage(
              imageUrl: e.url,
            ),
          );
        },
      ).toList();
      return Wrap(
        children: children,
      );
    } else if (chatMessage.type == TYPE_IMAGE_VARIATION) {
      OpenAIImageVariationModel variationModel =
          OpenAIImageVariationModel.fromJson(
              json.decode(chatMessage.promptResponse!));

      var children = variationModel.data.map(
        (e) {
          return Padding(
            padding: EdgeInsets.all(8.r),
            child: CachedNetworkImage(
              imageUrl: e.url,
            ),
          );
        },
      ).toList();
      return Wrap(
        children: children,
      );
    } else {
      throw FlutterError("Unknown message type");
    }
  }

  Widget _tipsTitle(BuildContext context, Widget header, Widget title) {
    return Row(
      children: [
        header,
        SizedBox(
          width: 8.w,
        ),
        title
      ],
    );
  }

  Widget _chatMessageItem(BuildContext context) {
    if (chatMessage.messageId == ChatGptConst.TIPS_ANSWER_QUESTIONS) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
                color: Color(0xFF21D8E8),
                borderRadius: BorderRadius.all(Radius.circular(12.r))),
            child: InkWell(
              onTap: () {
                editingController.text = chatMessage.queryPrompt!;
              },
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      _tipsTitle(
                          context,
                          SvgPicture.asset(
                              "assets/images/ic_question_tips.svg"),
                          Text(
                            S.of(context).answer_question_title,
                            style: TextStyle(
                                color: Color(0xFF1A9BA7),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 12.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: Color(0x66FFFFFF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.r)),
                            border:
                                Border.all(color: Colors.white, width: 0.5.r)),
                        child: Text(
                          chatMessage.queryPrompt!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      )
                    ]),
              ),
            ),
          ),
        ),
      );
    } else if (chatMessage.messageId == ChatGptConst.TIPS_CODE_HELPER) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
                color: Color(0xFF52ADFF),
                borderRadius: BorderRadius.all(Radius.circular(12.r))),
            child: InkWell(
              onTap: () {
                editingController.text = chatMessage.queryPrompt!;
              },
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      _tipsTitle(
                          context,
                          SvgPicture.asset(
                              "assets/images/ic_code_helper_tips.svg"),
                          Text(
                            S.of(context).code_assistant_title,
                            style: TextStyle(
                                color: Color(0xFF1B6FBB),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              color: Colors.white,
                              height: 4.r,
                              width: 4.r,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Expanded(
                              child: Text(
                            chatMessage.queryPrompt!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      )
                    ]),
              ),
            ),
          ),
        ),
      );
    } else if (chatMessage.messageId == ChatGptConst.TIPS_TRANSLATE_TOOL) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
                color: Color(0xFF4556C1),
                borderRadius: BorderRadius.all(Radius.circular(12.r))),
            child: InkWell(
              onTap: () {
                editingController.text = chatMessage.queryPrompt!;
              },
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      _tipsTitle(
                          context,
                          SvgPicture.asset(
                              "assets/images/ic_translate_tool.svg"),
                          Text(
                            S.of(context).translate_tool_title,
                            style: TextStyle(
                                color: Color(0xFF14258F),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              color: Colors.white,
                              height: 4.r,
                              width: 4.r,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Expanded(
                              child: Text(
                            chatMessage.queryPrompt!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      )
                    ]),
              ),
            ),
          ),
        ),
      );
    } else if (chatMessage.messageId == ChatGptConst.AIBot) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 16.r,
                    width: 16.r,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          color: Color(0xFF1DC338),
                        ))),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      child: getResponseWidget(chatMessage)),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 32.w),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: chatMessage.promptResponse!));
                        //toast("Copied");
                      },
                      child: Icon(Icons.copy, size: 24.r)),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                      onTap: () {
                        Share.share(chatMessage.promptResponse!);
                      },
                      child: Icon(Icons.share, size: 24.r)),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 16.r,
                width: 16.r,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      color: Color(0xFF6D2DF5),
                    ))),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                child: getInputWidget(chatMessage),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget getInputWidget(ChatMessageEntity chatMessage) {
    if (chatMessage.type == TYPE_IMAGE_VARIATION) {
      return Image.file(
        File(chatMessage.queryPrompt!),
        fit: BoxFit.cover,
      );
    } else {
      return MarkdownWidget(
        selectable: true,
        shrinkWrap: true,
        data: chatMessage.queryPrompt!,
      );
    }
  }
}
