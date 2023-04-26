import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';

import '../cubit/chat_conversation/chat_conversation_cubit.dart';

typedef ConversationSeleteCallback = void Function(int conversationId);

class ConversationWidget extends StatelessWidget {
  final ConversationSeleteCallback? onConversationTap;

  const ConversationWidget({required this.onConversationTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatConversationCubit, ChatConversationState>(
      buildWhen: (previous, current) => current is ChatConversationLoaded,
      builder: (context, chatConversationState) {
        if (chatConversationState is ChatConversationLoaded) {
          return ListView.builder(
              itemCount: chatConversationState.chatMessages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          if (chatConversationState.showConversationId !=
                              INVALID_CONVERSATION_ID) {
                            BlocProvider.of<ChatConversationCubit>(context)
                                .newConversation();
                            //_isVisible = false;
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            S.of(context).new_chat,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  var realIndex = index - 1;
                  var entry = chatConversationState.chatMessages.values
                      .elementAt(realIndex);
                  var title = S.of(context).new_conversation;
                  if (entry.isNotEmpty &&
                      (entry.first.queryPrompt?.isNotEmpty ?? false)) {
                    title = entry.first.queryPrompt!;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          onConversationTap?.call(chatConversationState
                              .chatMessages.keys
                              .elementAt(realIndex));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            title,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white),
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
    );
  }
}
