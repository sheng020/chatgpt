import 'dart:io';

import '../../models/audio/audio.dart';


abstract class CreateInterface {
  Future<OpenAIAudioModel> createTranscription({
    required File file,
    required String model,
    String? prompt,
    String? responseFormat,
    double? temperature,
    String? laungage,
  });

  Future<OpenAIAudioModel> createTranslation({
    required File file,
    required String model,
    String? prompt,
    String? responseFormat,
    double? temperature,
  });
}
