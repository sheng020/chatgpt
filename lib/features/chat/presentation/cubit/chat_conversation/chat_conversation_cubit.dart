import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/usecases/chat_converstaion_usecase.dart';
import 'package:flutter_chatgpt_clone/features/global/channel/native_channel.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/const/constants.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:flutter_chatgpt_clone/http/http_client.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

import '../../../../../database/database.dart';

part 'chat_conversation_state.dart';

const INVALID_CONVERSATION_ID = -1;
const USER_NAME = "user_name";
const DEFAULT_NAME = "CJS";

class ChatConversationCubit extends Cubit<ChatConversationState> {
  final ChatConversationUseCase chatConversationUseCase;

  ChatConversationCubit({required this.chatConversationUseCase})
      : super(ChatConversationInitial());

  List<ChatMessageEntity> _conversations = [];

  void setFloatingActionButtonShow(bool show) {
    emit(FloatingActionState(showFloatingActionButton: show));
  }

  int getCurrentConversationLength() {
    return _conversations.length;
  }

  void sendChatMessage(String message, {bool isRequestProcessing = false}) {
    emit(NotifyTextFieldState(
        message: message, isRequestProcessing: isRequestProcessing));
  }

  void startRealTimeTranslate(String text, {int? id}) async {
    if (text.isEmpty) return;
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.7);

    final List<IdentifiedLanguage> possibleLanguages =
        await languageIdentifier.identifyPossibleLanguages(text);
    var detectedLanguage = possibleLanguages.firstOrNull;
    var targetLanguage = "en";

    //默认翻译成en，如果原文检查到是en，翻译成系统语言
    if (detectedLanguage != null &&
        detectedLanguage.languageTag.startsWith("en")) {
      targetLanguage = PlatformDispatcher.instance.locale.languageCode;
    }

    if (id != null) {
      emit(TranslateStatus(id: id, requesting: true));
    }

    HttpClient.getInstance().translate(
      texts: [text],
      to: targetLanguage,
    ).then((value) {
      if (id == null) {
        emit(NotifyTextFieldState(
            message: text,
            isRequestProcessing: false,
            translation: value.data.texts.firstOrNull));
      } else {
        emit(TranslateStatus(id: id, requesting: false));
        var message = _conversations.firstWhere((element) => element.id == id);
        message.promptResponse = value.data.texts.firstOrNull;
        emit(ChatConversationLoaded(
            chatMessages: _conversations, isRequestProcessing: false));
      }
    }).catchError((e) {
      print(e);
    });
    //languageIdentifier.close();
  }

  //List<ChatMessageEntity> _chatMessages = [];
  //List<ConversationEntity> _conversations = [];

  Future<void> initMessageList() async {
    var database = DatabaseManager.getInstance();
    if (isNewUser()) {
      await database.insertMessage(ChatMessageEntity(
          messageId: ChatGptConst.TIPS_ANSWER_QUESTIONS,
          type: TYPE_CHAT,
          queryPrompt: S.current.answer_question_tips));
      await database.insertMessage(ChatMessageEntity(
          type: TYPE_CHAT,
          messageId: ChatGptConst.TIPS_CODE_HELPER,
          queryPrompt: S.current.code_helper_tips));
      await database.insertMessage(ChatMessageEntity(
          type: TYPE_CHAT,
          messageId: ChatGptConst.TIPS_TRANSLATE_TOOL,
          queryPrompt: S.current.translate_tool_tips));
      markAsRegularUser();
    }

    var historyList = await database.queryMessageList();

    List<ChatMessageEntity> chatMessages = [];

    if (historyList != null) {
      historyList.forEach((element) {
        chatMessages.add(element);
      });
      _conversations = chatMessages.reversed.toList();
    }
    emit(
      ChatConversationLoaded(
          chatMessages: _conversations, isRequestProcessing: false),
    );
    emit(NotifyTextFieldState(message: "", isRequestProcessing: false));
    emit(ConversationLeftCount(leftCount: getLeftCount()));
  }

  StreamController? _streamController;

  void closeStream() {
    _streamController?.close();
    _streamController = null;
  }

  Future<void> chatConversation(
      {required ChatMessageEntity chatMessage, required int type
      //required Function(bool isReqComplete) onCompleteReqProcessing,
      }) async {
    var database = DatabaseManager.getInstance();
    var chatMessages = _conversations;

    var realChatMessage = chatMessage;

    realChatMessage = ChatMessageEntity(
      id: chatMessage.id,
      type: chatMessage.type,
      messageId: chatMessage.messageId,
      queryPrompt: chatMessage.queryPrompt,
      promptResponse: chatMessage.promptResponse,
      date: DateTime.now().millisecondsSinceEpoch,
    );

    var id = await database.insertMessage(realChatMessage);
    realChatMessage.id = id;
    chatMessages.insert(0, realChatMessage);

    sendChatMessage("", isRequestProcessing: true);
    emit(
      ChatConversationLoaded(
          chatMessages: _conversations, isRequestProcessing: true),
    );

    //onCompleteReqProcessing(true);
    if (type == TYPE_CHAT || type == TYPE_REAL_TIME_TRANSLATE) {
      final conversationData =
          chatConversationUseCase.call(realChatMessage.queryPrompt!);

      StringBuffer sb = StringBuffer();

      ChatMessageEntity? lastMessage;

      _streamController = conversationData;

      conversationData.stream.listen(
        (streamChatCompletion) {
          final content = streamChatCompletion.choices.first.delta.content;
          //print(content);
          if (content != null) {
            if (lastMessage != null) {
              chatMessages.remove(lastMessage);
            } else {
              consumeOneTime().then((leftCount) {
                emit(ConversationLeftCount(leftCount: leftCount));
              });
            }

            sb.write(content);

            final chatMessageNewResponse = ChatMessageEntity(
                type: type,
                messageId: ChatGptConst.AIBot,
                date: DateTime.now().millisecondsSinceEpoch,
                promptResponse: sb.toString());
            chatMessages.insert(0, chatMessageNewResponse);
            lastMessage = chatMessageNewResponse;
            emit(ChatConversationLoaded(
                chatMessages: _conversations, isRequestProcessing: true));
          }
        },
        onError: (error) {
          print(error);
          closeStream();
          //onCompleteReqProcessing(false);
          final chatMessageErrorResponse = ChatMessageEntity(
              date: DateTime.now().millisecondsSinceEpoch,
              messageId: ChatGptConst.AIBot,
              type: type,
              promptResponse: error.message);

          chatMessages.insert(0, chatMessageErrorResponse);

          emit(ChatConversationLoaded(
              chatMessages: _conversations, isRequestProcessing: false));
        },
        cancelOnError: false,
        onDone: () {
          print("Done");
          closeStream();
          sendChatMessage("", isRequestProcessing: false);
          //onCompleteReqProcessing(false);
          emit(ChatConversationLoaded(
              chatMessages: _conversations, isRequestProcessing: false));
          ChatMessageEntity? chatLastMessage = lastMessage;
          if (chatLastMessage != null) {
            database.insertMessage(chatLastMessage).then((value) {
              _conversations[0].id = value;
              emit(
                ChatConversationLoaded(
                    chatMessages: _conversations, isRequestProcessing: false),
              );
            });
          }
        },
      );
    } else if (type == TYPE_IMAGE_GENERATION) {
      final imageResponse = await chatConversationUseCase
          .createImageGeneration(realChatMessage.queryPrompt!);
      final chatMessageNewResponse = ChatMessageEntity(
          type: type,
          messageId: ChatGptConst.AIBot,
          date: DateTime.now().millisecondsSinceEpoch,
          promptResponse: json.encode(imageResponse));
      chatMessages.insert(0, chatMessageNewResponse);
      emit(ChatConversationLoaded(
          chatMessages: _conversations, isRequestProcessing: false));
      sendChatMessage("", isRequestProcessing: false);
      var leftCount = await consumeOneTime();
      emit(ConversationLeftCount(leftCount: leftCount));
      database.insertMessage(chatMessageNewResponse);
    } else if (type == TYPE_IMAGE_VARIATION) {
      if (realChatMessage.queryPrompt == null) {
        emit(ChatConversationLoaded(
            chatMessages: _conversations, isRequestProcessing: false));
        sendChatMessage("", isRequestProcessing: false);
        return;
      }
      final imageResponse = await chatConversationUseCase
          .variation(File(realChatMessage.queryPrompt!));
      final chatMessageNewResponse = ChatMessageEntity(
          type: type,
          messageId: ChatGptConst.AIBot,
          date: DateTime.now().millisecondsSinceEpoch,
          promptResponse: json.encode(imageResponse));
      chatMessages.insert(0, chatMessageNewResponse);
      sendChatMessage("", isRequestProcessing: false);
      emit(ChatConversationLoaded(
          chatMessages: _conversations, isRequestProcessing: false));
      database.insertMessage(chatMessageNewResponse);
      var leftCount = await consumeOneTime();
      emit(ConversationLeftCount(leftCount: leftCount));
    } else {
      throw FlutterError("Unknown message type");
    }
  }

  void stopGeneration(int type) {
    if (type == TYPE_IMAGE_GENERATION || type == TYPE_IMAGE_VARIATION) {
      emit(
        ChatConversationLoaded(
            chatMessages: _conversations, isRequestProcessing: false),
      );
      emit(NotifyTextFieldState(message: "", isRequestProcessing: false));
    } else {
      closeStream();
    }
  }

  Future<int?> deleteChatMessage(int? chatId) async {
    if (chatId == null) return -1;
    var database = DatabaseManager.getInstance();

    return database.deleteMessage(chatId);
  }

  Future<void> startShowRewardAd() {
    return NativeChannel.showRewardAd().then((value) {
      if (value == true) {
        var leftCount = getLeftCount();
        leftCount += 3;
        writeLeftCount(leftCount);
        emit(ConversationLeftCount(leftCount: leftCount));
      }
    });
  }
}
