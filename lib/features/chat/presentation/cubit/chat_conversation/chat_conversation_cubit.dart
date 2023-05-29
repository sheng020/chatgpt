import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/conversation_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/usecases/chat_converstaion_usecase.dart';
import 'package:flutter_chatgpt_clone/features/global/channel/native_channel.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/const/constants.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';

import '../../../../../database/database.dart';

part 'chat_conversation_state.dart';

const INVALID_CONVERSATION_ID = -1;
const USER_NAME = "user_name";
const DEFAULT_NAME = "CJS";

class ChatConversationCubit extends Cubit<ChatConversationState> {
  final ChatConversationUseCase chatConversationUseCase;

  ChatConversationCubit({required this.chatConversationUseCase})
      : super(ChatConversationInitial());

  Map<int, List<ChatMessageEntity>> _conversations = {};

  void setFloatingActionButtonShow(bool show) {
    emit(FloatingActionState(showFloatingActionButton: show));
  }

  int getCurrentConversationLength() {
    return _conversations[selectedConversationId]?.length ?? -1;
  }

  void sendChatMessage(String message, {bool isRequestProcessing = false}) {
    emit(NotifyTextFieldState(
        selectedConversationId: selectedConversationId,
        message: message,
        isRequestProcessing: isRequestProcessing));
  }

  var selectedConversationId = INVALID_CONVERSATION_ID;

  //List<ChatMessageEntity> _chatMessages = [];
  //List<ConversationEntity> _conversations = [];

  Future<void> initMessageList() async {
    var database = DatabaseManager.getInstance();
    emit(ChatConversationLoading());
    var conversations = await database.queryConversationList();
    if (conversations == null || conversations.isEmpty) {
      emit(
        ChatConversationLoaded(
            showConversationId: INVALID_CONVERSATION_ID,
            chatMessages: _conversations,
            isRequestProcessing: false),
      );
      //_conversations.add(conversation);
    } else {
      //默认显示最下面的那个conversation

      var historyList = await DatabaseManager.getInstance().queryMessageList();

      conversations.forEach((conversation) {
        List<ChatMessageEntity> chatMessages = [];

        if (historyList != null) {
          historyList.forEach((element) {
            if (element.conversationId == conversation.conversationId) {
              chatMessages.add(element);
            }
          });
          _conversations[conversation.conversationId!] =
              chatMessages.reversed.toList();
        }
      });
      selectedConversationId = _conversations.entries.last.key;
      emit(
        ChatConversationLoaded(
            showConversationId: selectedConversationId,
            chatMessages: _conversations,
            isRequestProcessing: false),
      );
    }
    emit(NotifyTextFieldState(
        selectedConversationId: selectedConversationId,
        message: "",
        isRequestProcessing: false));
    emit(ConversationLeftCount(leftCount: getLeftCount()));
  }

  Future<void> newConversation() async {
    var newConversation = ConversationEntity();
    var database = DatabaseManager.getInstance();
    int id = await database.insertConversation(newConversation);
    newConversation.conversationId = id;
    _conversations[id] = [];
    selectedConversationId = _conversations.entries.last.key;
    emit(
      ChatConversationLoaded(
          showConversationId: selectedConversationId,
          chatMessages: _conversations,
          isRequestProcessing: false),
    );
    emit(NotifyTextFieldState(
        selectedConversationId: selectedConversationId,
        message: "",
        isRequestProcessing: false));
    setFloatingActionButtonShow(false);
  }

  Future<void> selectConversation(int conversationId) async {
    emit(ChatConversationLoaded(
        showConversationId: conversationId,
        chatMessages: _conversations,
        isRequestProcessing: false));
    selectedConversationId = conversationId;
    //setFloatingActionButtonShow(false);
  }

  StreamController? _streamController;

  void closeStream() {
    _streamController?.close();
    _streamController = null;
  }

  Future<void> chatConversation(
      {required int conversationId,
      required ChatMessageEntity chatMessage,
      required int type
      //required Function(bool isReqComplete) onCompleteReqProcessing,
      }) async {
    var database = DatabaseManager.getInstance();
    var chatMessages = _conversations[conversationId];

    var showConversationId = conversationId;
    var realChatMessage = chatMessage;
    if (chatMessages == null || conversationId == INVALID_CONVERSATION_ID) {
      //如果会话不存在，创建一个
      var conversation = ConversationEntity();
      int id = await database.insertConversation(conversation);
      conversation.conversationId = id;
      chatMessages = [];

      showConversationId = id;
      _conversations[id] = chatMessages;
    }

    realChatMessage = ChatMessageEntity(
        id: chatMessage.id,
        type: chatMessage.type,
        messageId: chatMessage.messageId,
        queryPrompt: chatMessage.queryPrompt,
        promptResponse: chatMessage.promptResponse,
        date: DateTime.now().millisecondsSinceEpoch,
        conversationId: showConversationId);

    var id = await database.insertMessage(realChatMessage);
    realChatMessage.id = id;
    chatMessages.insert(0, realChatMessage);

    selectedConversationId = showConversationId;
    sendChatMessage("", isRequestProcessing: true);
    emit(
      ChatConversationLoaded(
          showConversationId: showConversationId,
          chatMessages: _conversations,
          isRequestProcessing: true),
    );

    //onCompleteReqProcessing(true);
    if (type == TYPE_CHAT) {
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
              chatMessages?.remove(lastMessage);
            } else {
              consumeOneTime().then((leftCount) {
                emit(ConversationLeftCount(leftCount: leftCount));
              });
            }

            sb.write(content);

            final chatMessageNewResponse = ChatMessageEntity(
                type: type,
                conversationId: showConversationId,
                messageId: ChatGptConst.AIBot,
                date: DateTime.now().millisecondsSinceEpoch,
                promptResponse: sb.toString());
            chatMessages?.insert(0, chatMessageNewResponse);
            lastMessage = chatMessageNewResponse;
            emit(ChatConversationLoaded(
                showConversationId: showConversationId,
                chatMessages: _conversations,
                isRequestProcessing: true));
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

          chatMessages?.insert(0, chatMessageErrorResponse);

          emit(ChatConversationLoaded(
              showConversationId: showConversationId,
              chatMessages: _conversations,
              isRequestProcessing: false));
        },
        cancelOnError: false,
        onDone: () {
          print("Done");
          closeStream();
          sendChatMessage("", isRequestProcessing: false);
          //onCompleteReqProcessing(false);
          emit(ChatConversationLoaded(
              chatMessages: _conversations,
              showConversationId: showConversationId,
              isRequestProcessing: false));
          ChatMessageEntity? chatLastMessage = lastMessage;
          if (chatLastMessage != null) {
            DatabaseManager.getInstance().insertMessage(chatLastMessage);
          }
        },
      );
    } else if (type == TYPE_IMAGE_GENERATION) {
      final imageResponse = await chatConversationUseCase
          .createImageGeneration(realChatMessage.queryPrompt!);
      final chatMessageNewResponse = ChatMessageEntity(
          type: type,
          conversationId: showConversationId,
          messageId: ChatGptConst.AIBot,
          date: DateTime.now().millisecondsSinceEpoch,
          promptResponse: json.encode(imageResponse));
      chatMessages.insert(0, chatMessageNewResponse);
      emit(ChatConversationLoaded(
          showConversationId: showConversationId,
          chatMessages: _conversations,
          isRequestProcessing: false));
      sendChatMessage("", isRequestProcessing: false);
      var leftCount = await consumeOneTime();
      emit(ConversationLeftCount(leftCount: leftCount));
      DatabaseManager.getInstance().insertMessage(chatMessageNewResponse);
    } else if (type == TYPE_IMAGE_VARIATION) {
      if (realChatMessage.queryPrompt == null) {
        emit(ChatConversationLoaded(
            showConversationId: showConversationId,
            chatMessages: _conversations,
            isRequestProcessing: false));
        sendChatMessage("", isRequestProcessing: false);
        return;
      }
      final imageResponse = await chatConversationUseCase
          .variation(File(realChatMessage.queryPrompt!));
      final chatMessageNewResponse = ChatMessageEntity(
          type: type,
          conversationId: showConversationId,
          messageId: ChatGptConst.AIBot,
          date: DateTime.now().millisecondsSinceEpoch,
          promptResponse: json.encode(imageResponse));
      chatMessages.insert(0, chatMessageNewResponse);
      sendChatMessage("", isRequestProcessing: false);
      emit(ChatConversationLoaded(
          showConversationId: showConversationId,
          chatMessages: _conversations,
          isRequestProcessing: false));
      DatabaseManager.getInstance().insertMessage(chatMessageNewResponse);
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
            showConversationId: selectedConversationId,
            chatMessages: _conversations,
            isRequestProcessing: false),
      );
      emit(NotifyTextFieldState(
          selectedConversationId: selectedConversationId,
          message: "",
          isRequestProcessing: false));
    } else {
      closeStream();
    }
  }

  Future<void> deleteAllConversation() async {
    _conversations.forEach((key, value) async {
      await deleteConversation(key);
      value.forEach((element) async {
        await deleteChatMessage(element.id);
      });
    });
    _conversations.clear();
    selectedConversationId = INVALID_CONVERSATION_ID;
    emit(
      ChatConversationLoaded(
          showConversationId: INVALID_CONVERSATION_ID,
          chatMessages: _conversations,
          isRequestProcessing: false),
    );
  }

  Future<int?> deleteConversation(int conversationId) async {
    var database = DatabaseManager.getInstance();
    return database.deleteConversation(conversationId);
  }

  Future<int?> deleteChatMessage(int? chatId) async {
    if (chatId == null) return -1;
    var database = DatabaseManager.getInstance();

    return database.deleteMessage(chatId);
  }

  Future<void> startShowRewardAd() {
    return NativeChannel.showRewardAd().then((value) {
      print("get rewarded:${value}");
      if (value == true) {
        var leftCount = getLeftCount();
        leftCount += 3;
        writeLeftCount(leftCount);
        emit(ConversationLeftCount(leftCount: leftCount));
      }
    });
  }
}
