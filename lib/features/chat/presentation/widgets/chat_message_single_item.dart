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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../api/core/models/image/image/image.dart';
import '../cubit/chat_conversation/chat_conversation_cubit.dart';
import '../cubit/chat_conversation/chat_conversation_user_cubit.dart';

class ChatMessageSingleItem extends StatelessWidget {
  final ChatMessageEntity chatMessage;

  const ChatMessageSingleItem({Key? key, required this.chatMessage})
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

  Widget _chatMessageItem(BuildContext context) {
    if (chatMessage.messageId == ChatGptConst.AIBot) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: colorGrayLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 35.r,
                    width: 35.r,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset("assets/openAIChatbot.png"))),
                SizedBox(
                  width: 20.w,
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
              margin: EdgeInsets.only(left: 50.w),
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
              height: 35.r,
              width: 35.r,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Center(
                child: BlocBuilder<ChatUserNameCubit, ChatConversationState>(
                  builder: (context, conversationUser) {
                    if (conversationUser is ConversationUser) {
                      return Text(
                        conversationUser.userName,
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return Text(
                        "CJS",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                ),
              ),
            ),
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
