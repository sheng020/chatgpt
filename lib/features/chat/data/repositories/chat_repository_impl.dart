import 'dart:async';
import 'dart:io';

import 'package:flutter_chatgpt_clone/api/core/models/image/image/image.dart';
import 'package:flutter_chatgpt_clone/api/core/models/image/variation/variation.dart';
import 'package:flutter_chatgpt_clone/features/chat/data/remote_data_source/chat_remote_data_source.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/repositories/chat_repository.dart';

import '../../../../api/core/models/chat/stream/chat.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  StreamController<OpenAIStreamChatCompletionModel> chatConversation(
          String prompt) =>
      remoteDataSource.chatConversation(prompt);

  @override
  Future<OpenAIImageModel> createImageGeneration(String prompt) {
    return remoteDataSource.createImageGeneration(prompt);
  }

  Future<OpenAIImageVariationModel> variation(File image) {
    return remoteDataSource.variation(image);
  }
}
