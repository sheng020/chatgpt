import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/conversation_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/usecases/chat_converstaion_usecase.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';

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

  //List<ChatMessageEntity> _chatMessages = [];
  //List<ConversationEntity> _conversations = [];

  void initMessageList() async {
    var database = DatabaseManager.getInstance();
    emit(ChatConversationLoading());
    var conversations = await database.queryConversationList();
    if (conversations == null || conversations.isEmpty) {
      emit(
        ChatConversationLoaded(
          showConversationId: INVALID_CONVERSATION_ID,
          chatMessages: _conversations,
        ),
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
          _conversations[conversation.conversationId!] = chatMessages;
        }
      });
      emit(
        ChatConversationLoaded(
          showConversationId: _conversations.entries.last.key,
          chatMessages: _conversations,
        ),
      );
    }
  }
  
  Future<void> newConversation() async {
    var newConversation = ConversationEntity();
    var database = DatabaseManager.getInstance();
    int id = await database.insertConversation(newConversation);
    newConversation.conversationId = id;
    _conversations[id] = [];
    emit(
      ChatConversationLoaded(
        showConversationId: _conversations.entries.last.key,
        chatMessages: _conversations,
      ),
    );
  }
  
  Future<void> selectConversation(int conversationId) async {
    emit(ChatConversationLoaded(
      showConversationId: conversationId,
      chatMessages: _conversations,
    ));
  }

  Future<void> chatConversation({
    required int conversationId,
    required ChatMessageEntity chatMessage,
    required Function(bool isReqComplete) onCompleteReqProcessing,
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
        messageId: chatMessage.messageId,
        queryPrompt: chatMessage.queryPrompt,
        promptResponse: chatMessage.promptResponse,
        conversationId: showConversationId);
    chatMessages.add(realChatMessage);

    emit(
      ChatConversationLoaded(
        showConversationId: showConversationId,
        chatMessages: _conversations,
      ),
    );

    database.insertMessage(realChatMessage);

    onCompleteReqProcessing(true);

    final conversationData =
        chatConversationUseCase.call(realChatMessage.queryPrompt!);

    StringBuffer sb = StringBuffer();

    ChatMessageEntity? lastMessage;

    conversationData.listen(
      (streamChatCompletion) {
        final content = streamChatCompletion.choices.first.delta.content;
        //print(content);
        if (content != null) {
          if (lastMessage != null) {
            chatMessages?.remove(lastMessage);
          }

          sb.write(content);

          final chatMessageNewResponse = ChatMessageEntity(
              conversationId: showConversationId,
              messageId: ChatGptConst.AIBot,
              promptResponse: sb.toString());
          chatMessages?.add(chatMessageNewResponse);
          lastMessage = chatMessageNewResponse;
          emit(ChatConversationLoaded(
            showConversationId: showConversationId,
            chatMessages: _conversations,
          ));
        }
      },
      onError: (error) {
        print(error);
        onCompleteReqProcessing(false);
        final chatMessageErrorResponse = ChatMessageEntity(
            messageId: ChatGptConst.AIBot, promptResponse: error.message);

        chatMessages?.add(chatMessageErrorResponse);

        emit(ChatConversationLoaded(
          showConversationId: showConversationId,
          chatMessages: _conversations,
        ));
      },
      cancelOnError: false,
      onDone: () {
        print("Done");
        onCompleteReqProcessing(false);
        ChatMessageEntity? chatLastMessage = lastMessage;
        if (chatLastMessage != null) {
          DatabaseManager.getInstance().insertMessage(chatLastMessage);
        }
      },
    );

    /*final chatMessageResponse = ChatMessageEntity(
          messageId: ChatGptConst.AIBot,
          promptResponse: conversationData.choices!.first.message.content);

      _chatMessages.add(chatMessageResponse);

      emit(ChatConversationLoaded(
        chatMessages: _chatMessages,
      ));*/
  }
}
