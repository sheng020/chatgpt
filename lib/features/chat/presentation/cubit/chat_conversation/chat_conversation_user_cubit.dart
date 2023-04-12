
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import 'chat_conversation_cubit.dart';

class ChatUserNameCubit extends Cubit<ChatConversationState> {

  ChatUserNameCubit() : super(ConversationUser(userName: box.read(USER_NAME) ?? DEFAULT_NAME));

  void changeUserName(String userName) {
    box.write(USER_NAME, userName);
    emit(ConversationUser(userName: userName));
  }

}