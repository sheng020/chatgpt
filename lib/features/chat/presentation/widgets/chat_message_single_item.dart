import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chatgpt_clone/api/core/models/image/variation/variation.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/style.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../../api/core/models/image/image/image.dart';
import '../cubit/chat_conversation/chat_conversation_cubit.dart';
import '../cubit/chat_conversation/chat_conversation_user_cubit.dart';

class ChatMessageSingleItem extends StatelessWidget {
  final ChatMessageEntity chatMessage;
  final TextEditingController editingController;

  const ChatMessageSingleItem({Key? key, required this.chatMessage, required this.editingController})
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
        config: MarkdownConfig.darkConfig,
        padding: EdgeInsets.zero,
        //syntaxHighlighter: Highlighter(),
      );
    } else if (chatMessage.type == TYPE_IMAGE_GENERATION) {
      OpenAIImageModel imageModel =
          OpenAIImageModel.fromJson(json.decode(chatMessage.promptResponse!));
      var children = imageModel.data.map(
        (e) {
          print("image generation:${e.url}");
          return Padding(
            padding: EdgeInsets.all(8),
            child: Image.network(e.url),
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
            padding: EdgeInsets.all(8),
            child: Image.network(e.url),
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
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 150),
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
                    height: 35,
                    width: 35,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset("assets/openAIChatbot.png"))),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: getResponseWidget(chatMessage),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: chatMessage.promptResponse!));
                        //toast("Copied");
                      },
                      child: Icon(Icons.copy, size: 18)),
                  SizedBox(
                    width: 10,
                  ),
                  /*InkWell(
                      onTap: () {
                        Share.share(chatMessage.promptResponse!);
                      },
                      child: Icon(Icons.share, size: 18)),*/
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 150),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(8)),
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
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  getInputWidget(chatMessage),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                        onPressed: () {
                          editingController.text = chatMessage.queryPrompt!;
                        },
                        icon: Icon(Icons.arrow_circle_down)),
                  )
                ],
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
        padding: EdgeInsets.zero,
      );
    }
  }
}
